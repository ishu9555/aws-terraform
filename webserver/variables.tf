variable "instance_type" {
  description = "Instance specs"
}

variable "az1" {}
variable "az2" {}

variable "key_name" {
}

variable "env_prefix" {
  default = "dev"
}

variable "vpc_security_group_ids" {
}

variable "subnet1" {

}

variable "subnet2" {

}