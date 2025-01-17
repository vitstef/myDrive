# MyDrive

Following document describes how to use provided Terraform module for deployment of myDrive application.  

[Main myDrive website](https://mydrive-storage.com/)

In result myDrive application will be available via:  
&emsp;HTTP - http.vitstef.ga (default) or http-${var.env}.vitstef.ga  
&emsp;HTTPS - mydrive.vitstef.ga (default) or mydrive-${var.env}.vitstef.ga  

# ![Diagram](diagrams/diagram.png)

## Index

* [Environment Variables](#environment-variables)
* [Installation](#installation)


## Environment Variables

These variables could be added in "module" section:  
&emsp;- "env" (optional): default - "prod"  
&emsp;- "mongodb-ip" (optional): default - "*hidden*" (IP address of VM where mongodb is installed, i.e. mongodb://\[ip_address\])  
&emsp;- "key" (optional): default - "*hidden*" (Encryption key for data)  
&emsp;- "remote-url" (optional): default - "http://localhost:3000" (This is the URL that the client navigates to in their browser in order to access myDrive.)  
&emsp;- "password" (optional): default - "*hidden*" (Sets myDrive init password.)  
&emsp;- "password-access" (optional): default - "*hidden*" (Sets the JWT secret for access tokens.)  
&emsp;- "password-refresh" (optional): default - "*hidden*" (Sets the JWT secret for access tokens.)  
&emsp;- "password-cookie" (optional): default - "*hidden*" (Sets the secret for cookies.)  
&emsp;- "s3-id" (optional): default - "*hidden*" (Sets the Amazon S3 ID.)  
&emsp;- "s3-key" (optional): default - "*hidden*" (Sets the Amazon S3 Key.)  
&emsp;- "image-repo" (optional): default - "us-central1-docker.pkg.dev/just-student-344815/github-docker-repo/mydrive-app" (Sets image name to de deployed to GCR. Image should have TAG ="env" variable)  
&emsp;- "gcr-service-location" (optional): default - "us-central1"  
&emsp;- "vpc-access-connector" (optional): default - "projects/just-student-344815/locations/us-central1/connectors/mydrive-app-to-mongo-vm" (Sets Serverless VPC access resource name)  
&emsp;- "gcr-network-endpoint-group-region" (optional): default - "us-central1"  
&emsp;- "google-project" (optional): default - "just-student-344815"  

## Installation

# ![Deployment](diagrams/deployment.png)

Required:  
&emsp;- AWS access key + secret key in file *myDrive/terraform/deploy-to-gcr/mydrive-gcr-project/mycreds-aws*  
&emsp;- GCP creds in file *myDrive/terraform/deploy-to-gcr/mydrive-gcr-project/mycreds-gcp.json*  
&emsp;- Decrypt (sops --decrypt \[file\]) varable.tf file in *myDrive/terraform/deploy-to-gcr/modules/mydrive-gcr/variables.enc.tf*  
&emsp;- Set your region and project in "provider" sections in main.tf  

Run:  
&emsp;*terraform init*  
&emsp;*terraform apply*  
&emsp;in folder myDrive/terraform/deploy-to-gcr/mydrive-gcr-project/  
