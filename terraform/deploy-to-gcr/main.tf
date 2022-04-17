provider "google" {
  credentials = file ("mycreds-gcp.json")
  project = "just-student-344815"
}

data "google_secret_manager_secret" "qa" {
  secret_id = "mydrive-vars"
}

resource "google_cloud_run_service" "default" {
  name     = "mydrive-terraform"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/just-student-344815/github-docker-repo/mydrive-app:latest"
	env {
         name = "MONGODB_URL"
         value = "mongodb://vitstef:VitStef89@cluster0-shard-00-00.nv76x.mongodb.net:27017,cluster0-shard-00-01.nv76x.mongodb.net:27017,cluster0-shard-00-02.nv76x.mongodb.net:27017/myFirstDatabase?ssl=true&replicaSet=atlas-easmlr-shard-0&authSource=admin&retryWrites=true&w=majority"
         }
        env {
          name = "KEY"
          value = "1234567890"
          }
        env {
          name = "REMOTE_URL"
          value = "http://localhost:3000"
          }
        env {
          name = "DB_TYPE"
          value = "mongo"
          }
        env {
          name = "PASSWORD"
          value = "1234567890"
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
          value = "1234567890"
          }
        env {
          name = "PASSWORD_REFRESH"
          value = "1234567890"
          }
        env {
          name = "PASSWORD_COOKIE"
          value = "1234567890"
          }

      ports {
            container_port = 3000
      }
      resources {
            limits   = {
                cpu    = "2000m"
                memory = "1024Mi"
      		}
      	   }      
      }
 
      
    }
        metadata {
    annotations = {
      "autoscaling.knative.dev/minScale" = "2"
      "autoscaling.knative.dev/maxScale" = "2"
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
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

