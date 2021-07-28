provider "aws" {
    region = var.region
    secret_key = var.aws_secret_key
    access_key = var.aws_access_key
}

variable "env_prefix" {
  default = "dev"
}

variable "region" {
  default = "ap-south-1"
  
}

variable "aws_access_key" {  
}

variable "aws_secret_key" {  
}


resource "aws_s3_bucket" "backend-bucket" {
    bucket = "${var.env_prefix}-backend-tf-s3-bucket"
    acl = "private"

    versioning {
        enabled = "true"
    }
    lifecycle {
    prevent_destroy = true
    }

    tags = {
        Name = "${var.env_prefix}-tf-backend"
    }  
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.env_prefix}-app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "backend-bucket" {
	value = aws_s3_bucket.backend-bucket.bucket
  
}