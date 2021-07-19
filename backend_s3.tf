resource "aws_s3_bucket" "backend-bucket" {
    bucket = "${var.env_prefix}-backend-tf-s3-bucket"
    acl = "private"

    versioning {
        enabled = "true"
    }

    tags = {
        Name = "${var.env_prefix}-tf-backend"

    }
  
}