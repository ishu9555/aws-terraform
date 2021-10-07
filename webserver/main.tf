## Data fetch from AWS to get the ami info being used.

data "aws_ami" "myapp-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}

## Creation of Ec2 instances {web servers with nginx container}

### First instance 

resource "aws_instance" "myapp-webserver-instance-1" {
  ami                         = data.aws_ami.myapp-ami.id
  instance_type               = var.instance_type
  availability_zone           = var.az1
  vpc_security_group_ids      = var.vpc_security_group_ids ##[aws_security_group.myapp-security-group.id]
  subnet_id                   = var.subnet1
  key_name                    = var.key_name
  associate_public_ip_address = true
  # 	user_data = << EOF
  # #!/bin/bash
  # sudo yum update -y && sudo yum install -y docker 
  # sudo systemctl start docker && sudo systemctl enable docker
  # sudo usermod -aG docker ec2-user
  # sudo docker run -p 8080:80 nginx
  # EOF 	
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "${var.env_prefix}-webserver-instance-1"
    "role" = "${var.env_prefix}-webserver-1"
    "type" = "${var.env_prefix}-nginx-1"
  }
}

### Second instance 

resource "aws_instance" "myapp-webserver-instance-2" {

  ami                         = data.aws_ami.myapp-ami.id
  instance_type               = var.instance_type
  availability_zone           = var.az2
  vpc_security_group_ids      = var.vpc_security_group_ids ## [aws_security_group.myapp-security-group.id]
  subnet_id                   = var.subnet2
  key_name                    = var.key_name
  associate_public_ip_address = true
  # 	user_data = << EOF
  # #! /bin/bash
  # sudo yum update -y && sudo yum install -y docker 
  # sudo systemctl start docker && sudo systemctl enable docker
  # sudo usermod -aG docker ec2-user
  # sudo docker run -p 8080:80 nginx 
  # EOF
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.env_prefix}-webserver-instance-2"
    "role" = "${var.env_prefix}-webserver-2"
    "type" = "${var.env_prefix}-nginx-2"
  }
}
