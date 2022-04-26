variable "env" {
 type        = string
 default = "prod"
}

variable "key" {
  type    = string
  default = "1234567890"
  sensitive = true
}

variable "remote-url" {
 type        = string
 default     = "http://localhost:3000"
}

variable "password" {
  type    = string
  default = "1234567890"
  sensitive = true
}

variable "password-access" {
  type    = string
  default = "1234567890"
  sensitive = true
}

variable "password-refresh" {
  type    = string
  default = "1234567890"
  sensitive = true
}

variable "password-cookie" {
  type    = string
  default = "1234567890"
  sensitive = true
}

locals {
  image-tag = "${ var.env == "prod" ? "latest" : var.env}"
  subdomain = "${ var.env == "prod" ? "" : "-${var.env}"}"
}

#

variable "mongodb-ip" {
  type    = string
}

variable "s3-id" {
 type        = string
 sensitive = true
}

variable "s3-key" {
 type        = string
 sensitive = true
}

variable "image-repo" {
  type    = string
}

variable "gcr-service-location" {
  type    = string
}

variable "vpc-access-connector" {
  type    = string
}

variable "gcr-network-endpoint-group-region" {
  type    = string
}

variable "google-project" {
  type    = string
}

#

variable vm-size {
  type = string
  default = ""
}

variable limit-switch {
  type = map
  default = {
    "" = 0
    "small" = 1
    "medium" = 2
    "large" = 3
  }
}

variable "limits"{
  type = list(object({
      cpu = number,
      memory = string       
  }))
  default = [{
      cpu = null,
      memory = null

  },
  {
      cpu = 1,
      memory = "1Gi"    
  },
  {
      cpu = 2,
      memory = "2Gi"    
  },
  {
      cpu = 4,
      memory = "4Gi"    
  }]
}
