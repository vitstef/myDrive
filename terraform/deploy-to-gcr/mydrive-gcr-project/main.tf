terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.16.0"
      }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["mycreds-aws"]
}

provider "google" {
  credentials = file ("mycreds-gcp.json")
  project = "just-student-344815"
  region = "us-central1"
}

module "mydrive-prod" {
  source = "../modules/mydrive-gcr"
}

module "mydrive-dev" {
  source = "../modules/mydrive-gcr"
  env = "dev"
#  key = "0987654321"
#  password = "0987654321"
#  password-access = "0987654321"
#  password-refresh = "0987654321"
#  password-cookie = "0987654321"

}