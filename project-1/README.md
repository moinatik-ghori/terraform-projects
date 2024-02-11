# Deploying Static Website on AWS S3 using Terraform

This repository contains Terraform configuration files to deploy a static website on AWS S3.

## Overview

The Terraform configuration in this repository creates the necessary AWS resources to host a static website, including an S3 bucket, S3 bucket ownership controls, public access settings, ACLs, and website configuration.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- [Terraform](https://www.terraform.io/) installed on your local machine.
- AWS credentials configured on your machine with the necessary permissions.

## Getting Started

Follow these steps to deploy the static website:

1. Clone this repository:

    ```bash
    git clone git@github.com:moinatik-ghori/terraform-projects.git
    cd terraform-projects/project-1
    ```

2. Check out the `main.tf` file with all resources.
```hcl
resource "aws_s3_bucket" "mg-bucket-103" {
  bucket = var.proj1-s3-bucket
}
```
This block defines an AWS S3 bucket using the aws_s3_bucket resource type. It creates an S3 bucket with a specific name specified by the variable var.proj1-s3-bucket. This variable is defined in variable.tf in Terraform configuration and provide a unique name for S3 bucket.

```hcl
resource "aws_s3_bucket_ownership_controls" "ownership-control" {
  bucket = aws_s3_bucket.mg-bucket-103.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```
This block defines the ownership controls for the S3 bucket using the aws_s3_bucket_ownership_controls resource type. It specifies that the object ownership in the bucket should be set to "BucketOwnerPreferred."

```hcl
resource "aws_s3_bucket_public_access_block" "public-access-block" {
  bucket = aws_s3_bucket.mg-bucket-103.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```
This block configures public access settings for the S3 bucket using the aws_s3_bucket_public_access_block resource type. It explicitly sets various parameters to allow public access to the bucket. Note that in a production environment, you might want to adjust these settings based on your security requirements.

```hcl
resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership-control,
    aws_s3_bucket_public_access_block.public-access-block,
  ]

  bucket = aws_s3_bucket.mg-bucket-103.id
  acl    = "public-read"
}
```
This block configures the Access Control List (ACL) for the S3 bucket using the aws_s3_bucket_acl resource type. It sets the ACL to "public-read," allowing public read access to the objects in the bucket. The depends_on attribute ensures that this resource is created after the specified dependencies (ownership-control and public-access-block) have been created.

```hcl
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mg-bucket-103.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"
}
```
This block defines an S3 object (file) using the aws_s3_object resource type. It specifies an object with the key "index.html" in the S3 bucket, sourced from a local file named "index.html." The content_type is set to "text/html," and the ACL is configured for "public-read."

```hcl
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mg-bucket-103.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"
}
```
Similar to the previous block, this one defines another S3 object for an error page with the key "error.html." It is sourced from a local file named "error.html," and the content type and ACL are set accordingly.

```hcl
resource "aws_s3_bucket_website_configuration" "ws-config" {
  bucket = aws_s3_bucket.mg-bucket-103.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.acl]
}
```
This block configures the S3 bucket to serve as a static website using the aws_s3_bucket_website_configuration resource type. It specifies the index.html file as the index document and the error.html file as the error document. The depends_on attribute ensures that this resource is created after the ACL configuration.

These Terraform blocks work together to define and configure AWS resources for hosting a static website on S3.

3. Initialize the Terraform configuration:

    ```bash
    terraform init
    ```
4. Review the execution plan:

    ```bash
    terraform plan
    ```
5. Apply the configuration to create AWS resources:

    ```bash
    terraform apply
    ```
6. Confirm by entering "yes" when prompted.

7. Once the deployment is complete, you can access your static website using the S3 bucket URL.

8. After completing your project,  destroy the infrastructure you created.

    ```bash
    terraform destroy
    ```
   


