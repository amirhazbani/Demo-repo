#Refrance https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging
#terrafom init - Create the terrafrom files from the mian.tg
#terrafom plan - validate the configuration
#terrafom apply - apply the config on aws



#Task: Privete S3 +Tags+server access enable

#allow Terraform to interact with cloud providers in this example AWS.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
    access_key = "XXXXX"
    secret_key = "XXXXX"
    region = "eu-central-1"
}

#Create S3 bucket, tags and prepare S3 bucket to receive logs

resource "aws_s3_bucket" "amirbucketqa" {
  bucket = "amirbucketqa"
  acl = "log-delivery-write"
  tags = {
    department = "Security team"
    Enviorment = "QA"
  }
}

#Blocking public access to your Amazon S3 storage

resource "aws_s3_bucket_public_access_block" "amirbucketqa" {
  bucket = aws_s3_bucket.amirbucketqa.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Provides an S3 bucket (server access) logging resource.

resource "aws_s3_bucket_logging" "amirbucketqa" {
  bucket = aws_s3_bucket.amirbucketqa.id

  target_bucket = aws_s3_bucket.amirbucketqa.id
  target_prefix = "logs"
}