variable "aws_access_key" {
  description = "AWS sign in access key"
}

variable "aws_secret_key" {
  description = "AWS secret key for sign in to AWS account"
}
variable "key_name" {}
variable "vpc_cidr_block" {}
variable "env_prefix" {}

variable "subnet1_cidr_block" {}
variable "all_cidr" {}
variable "az1" {}
variable "az2" {}


variable "subnet2_cidr_block" {}


variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}