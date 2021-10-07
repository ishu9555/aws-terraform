terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  secret_key = var.aws_secret_key
  access_key = var.aws_access_key

}

terraform {
  backend "s3" {
    bucket = "dev-backend-tf-s3-bucket"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
