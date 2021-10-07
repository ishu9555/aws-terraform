# [VPC (subnet)(IG)(RT)(SG(egress,ingress,association_RT)) , EC2 (AMI)(instance)]

## VPC creation

resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}


#module subnet 

module "subnet" {
  source = "./subnets"

  subnet1_cidr_block = var.subnet1_cidr_block
  subnet2_cidr_block = var.subnet2_cidr_block
  vpc_id             = aws_vpc.myapp_vpc.id
  az1                = "ap-south-1a"
  az2                = "ap-south-1b"
  env_prefix         = "dev"


}


## webserver module 

module "instance" {
  source = "./webserver"

  instance_type          = var.instance_type
  az1                    = var.az1
  az2                    = var.az2
  key_name               = var.key_name
  env_prefix             = ""
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  subnet1                = module.subnet.myapp-subnet1_id ##var.subnet1
  subnet2                = module.subnet.myapp-subnet2_id
}
## Security Group creation

resource "aws_security_group" "myapp-security-group" {
  vpc_id      = aws_vpc.myapp_vpc.id
  description = "Allow SSH and HTTP traffic on EC2 instance"
  name        = "myapp-sg-terraform"
  ingress {
    cidr_blocks = [var.all_cidr]
    description = "SSH inbound rule for all sources"
    from_port   = 22
    protocol    = "TCP"
    self        = true
    to_port     = 22
  }
  ingress {
    cidr_blocks = [var.all_cidr]
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    self        = true
    description = "HTTP rule on port 8080 for all sources"
  }
  egress {
    cidr_blocks     = [var.all_cidr]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    description     = "Outbond traffic rule"
    prefix_list_ids = []
  }
  tags = {
    "Name" = "${var.env_prefix}-sg"
  }

}

## AWS LB creation 

resource "aws_lb" "myapp-lb" {
  security_groups = [aws_security_group.myapp-security-group.id]
  internal        = false
  subnets         = [module.subnet.myapp-subnet1_id, module.subnet.myapp-subnet2_id]
  tags = {
    "Name" = "${var.env_prefix}-lb"
    "type" = "application-${var.env_prefix}-lb"
  }
}

## AWS LB listerner policy created 

resource "aws_lb_listener" "myapp-lb-ls" {
  load_balancer_arn = aws_lb.myapp-lb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.myapp-lb-tg.arn
    type             = "forward"
  }

}

## AWS LB target group created 

resource "aws_lb_target_group" "myapp-lb-tg" {
  vpc_id      = aws_vpc.myapp_vpc.id
  port        = 8080
  protocol    = "HTTP"
  name        = "myapp-lb-tg"
  target_type = "instance"
}

## AWS target group attachment with Instances 

### First instance 

resource "aws_lb_target_group_attachment" "myapp-lb-tg-1a" {
  target_group_arn = aws_lb_target_group.myapp-lb-tg.arn
  port             = 8080
  target_id        = module.instance.webserver1_id

}

### Second instance 

resource "aws_lb_target_group_attachment" "myapp-lb-tg-2a" {
  target_group_arn = aws_lb_target_group.myapp-lb-tg.arn
  port             = 8080
  target_id        = module.instance.webserver2_id
}

