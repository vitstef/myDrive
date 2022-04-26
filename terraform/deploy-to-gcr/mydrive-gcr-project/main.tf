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
  region = var.aws-region
  shared_credentials_files = ["mycreds-aws"]
}

provider "google" {
  credentials = file ("mycreds-gcp.json")
  project = var.google-project
  region = var.google-region
}

module "mydrive" {
  source = "../modules/mydrive-gcr"
  mongodb-ip = var.mongodb-ip
  s3-id = var.s3-id
  s3-key = var.s3-key
  image-repo = var.image-repo
  gcr-service-location = var.gcr-service-location
  vpc-access-connector = var.vpc-access-connector
  gcr-network-endpoint-group-region = var.gcr-network-endpoint-group-region
  google-project = var.google-project
  vm-size = "medium"
}

module "mydrive-qa" {
  source = "../modules/mydrive-gcr"
  env = "qa"
  mongodb-ip = var.mongodb-ip
  s3-id = var.s3-id
  s3-key = var.s3-key
  image-repo = var.image-repo
  gcr-service-location = var.gcr-service-location
  vpc-access-connector = var.vpc-access-connector
  gcr-network-endpoint-group-region = var.gcr-network-endpoint-group-region
  google-project = var.google-project
  vm-size = "small"
}

module "mydrive-training" {
  source = "../modules/mydrive-gcr"
  env = "training"
  mongodb-ip = var.mongodb-ip
  s3-id = var.s3-id
  s3-key = var.s3-key
  image-repo = var.image-repo
  gcr-service-location = "australia-southeast1"
  vpc-access-connector = "projects/just-student-344815/locations/australia-southeast1/connectors/mydrive-app-to-mongo-vm"
  gcr-network-endpoint-group-region = var.gcr-network-endpoint-group-region
  google-project = var.google-project
  vm-size = var.vm-size
}