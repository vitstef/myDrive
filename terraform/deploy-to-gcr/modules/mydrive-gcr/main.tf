# AWS S3 Bucket Creation
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.env}-mydrive"
  force_destroy = "true"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
	sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_account_public_access_block" "s3_account_public_access_block" {
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Google Part[var.env]
// Cloud Run deploy
resource "google_cloud_run_service" "this" {
  name     = "${var.env}-mydrive-terraform"
  location = var.gcr-service-location
  template {
    spec {
      containers {
        image = "${var.image-repo}:${local.image-tag}"
	      env {
         name = "MONGODB_URL"
         value = "${var.mongodb-ip}/${var.env}-mydrive-db"
         }
        env {
          name = "KEY"
          value = var.key
          }
        env {
          name = "REMOTE_URL"
          value = var.remote-url
          }
        env {
          name = "DB_TYPE"
          value = "s3"
          }
        env {
          name = "PASSWORD"
          value = var.password
          }
        env {
          name = "DISABLE_STORAGE"
          value = "true"
          }
        env {  
          name = "DOCKER"
          value = "true"
          }
        env {
          name = "NODE_ENV"
          value = "production"
          }
        env {
          name = "HTTP_PORT"
          value = "3000"
	        }
	      env {
          name = "DISABLE_EMAIL_VERIFICATION"
          value = "true"
          }
        env {
          name = "PASSWORD_ACCESS"
          value = var.password-access
          }
        env {
          name = "PASSWORD_REFRESH"
          value = var.password-refresh
          }
        env {
          name = "PASSWORD_COOKIE"
          value = var.password-cookie
          }
        env {
          name = "S3_BUCKET"
          value = "${var.env}-mydrive"
          }
        env {
          name = "S3_ID"
          value = var.s3-id
          }
        env {
          name  = "S3_KEY"
          value = var.s3-key
          }

      ports {
            container_port = 3000
      }
      resources {
            limits   = {
                cpu    = "2000m"
                memory = "1Gi"
      		}
      	   }      
      }
 
    }
        metadata {
    annotations = {
      "autoscaling.knative.dev/minScale" = "2"
      "autoscaling.knative.dev/maxScale" = "2"
      "run.googleapis.com/client-name"   = "cloud-console"
      "run.googleapis.com/vpc-access-connector" = var.vpc-access-connector
      "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
    }
  } 
  }
  

  metadata {
    annotations = {
      generated-by = "magic-modules"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
        metadata.0.annotations,
    ]
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.this.location
  project     = google_cloud_run_service.this.project
  service     = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

// Network endpoint group creation
resource "google_compute_region_network_endpoint_group" "this" {
  name                  = "${var.env}-mydrive-terraform"
  network_endpoint_type = "SERVERLESS"
  region                = var.gcr-network-endpoint-group-region
  cloud_run {
    service = google_cloud_run_service.this.name
  }
}

// Load Balancer creation
// Get SSL Certificate data
data "google_compute_ssl_certificate" "this" {
  name = "letsencrypt-vitstef-ga"
}

// LB Backend
resource "google_compute_backend_service" "this" {
  affinity_cookie_ttl_sec = "0"

  backend {
    balancing_mode               = "UTILIZATION"
    capacity_scaler              = "0"
    group                        = google_compute_region_network_endpoint_group.this.id
    max_connections              = "0"
    max_connections_per_endpoint = "0"
    max_connections_per_instance = "0"
    max_rate                     = "0"
    max_rate_per_endpoint        = "0"
    max_rate_per_instance        = "0"
    max_utilization              = "0"
  }

  connection_draining_timeout_sec = "0"
  enable_cdn                      = "false"
  load_balancing_scheme           = "EXTERNAL"

  log_config {
    enable      = "false"
    sample_rate = "0"
  }

  name             = "${var.env}-mydrive-lb-backend"
  port_name        = "http"
  project          = var.google-project
  protocol         = "HTTPS"
  session_affinity = "NONE"
  timeout_sec      = "30"
}

resource "google_compute_url_map" "this" {
  default_service = google_compute_backend_service.this.id
  name            = "${var.env}-mydrive-lb"
  project         = var.google-project
}


// LB http-proxy
resource "google_compute_target_http_proxy" "http" {
  name       = "${var.env}-mydrive-lb-http-proxy"
  project    = var.google-project
  proxy_bind = "false"
  url_map    = google_compute_url_map.this.id
}

// LB https-proxy
resource "google_compute_target_https_proxy" "https" {
  name             = "${var.env}-mydrive-lb-https-proxy"
  project          = var.google-project
  proxy_bind       = "false"
  quic_override    = "NONE"
  ssl_certificates = [data.google_compute_ssl_certificate.this.id]
  url_map          = google_compute_url_map.this.id
}

// LB Frontend
resource "google_compute_global_forwarding_rule" "http" {
  ip_protocol           = "TCP"
  ip_version            = "IPV4"
  load_balancing_scheme = "EXTERNAL"
  name                  = "${var.env}-mydrive-lb-forwarding-rule-http"
  port_range            = "80-80"
  project               = var.google-project
  target                = google_compute_target_http_proxy.http.id
}

resource "google_compute_global_forwarding_rule" "https" {
  ip_protocol           = "TCP"
  ip_version            = "IPV4"
  load_balancing_scheme = "EXTERNAL"
  name                  = "${var.env}-mydrive-lb-forwarding-rule-https"
  port_range            = "443-443"
  project               = var.google-project
  target                = google_compute_target_https_proxy.https.id
}

// DNS data

data "google_dns_managed_zone" "this" {
  name = "vitstef-ga"
  project       = var.google-project
}

// DNS records
resource "google_dns_record_set" "http-A" {
  managed_zone = data.google_dns_managed_zone.this.name
  name         = "http${local.subdomain}.${data.google_dns_managed_zone.this.dns_name}"
  project      = var.google-project
  rrdatas      = [google_compute_global_forwarding_rule.http.ip_address]
  ttl          = "300"
  type         = "A"
}

resource "google_dns_record_set" "https-A" {
  managed_zone = data.google_dns_managed_zone.this.name
  name         = "mydrive${local.subdomain}.${data.google_dns_managed_zone.this.dns_name}"
  project      = var.google-project
  rrdatas      = [google_compute_global_forwarding_rule.https.ip_address]
  ttl          = "300"
  type         = "A"
}