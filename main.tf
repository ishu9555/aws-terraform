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

	subnet1_cidr_block  = "10.0.10.0/24"
	subnet2_cidr_block  = "10.0.30.0/24"
	vpc_id			        = aws_vpc.myapp_vpc.id
  az1                 = "ap-south-1a"
  az2                 = "ap-south-1b"
  env_prefix          = "dev"

  
}
## Security Group creation

resource "aws_security_group" "myapp-security-group" {
    vpc_id = aws_vpc.myapp_vpc.id
    description = "Allow SSH and HTTP traffic on EC2 instance"
		name = "myapp-sg-terraform"
    ingress  {
      cidr_blocks = [var.all_cidr]
      description = "SSH inbound rule for all sources"
      from_port = 22
      protocol = "TCP"      
      self = true
      to_port = 22
    } 
    ingress {
        cidr_blocks = [var.all_cidr]
				from_port = 8080
				to_port = 8080
				protocol = "TCP"
				self = true
				description = "HTTP rule on port 8080 for all sources"
    }
		egress {
			  cidr_blocks = [var.all_cidr]
				from_port = 0
				to_port = 0
				protocol = "-1"
				description = "Outbond traffic rule"
				prefix_list_ids = []
		}
		tags = {
			"Name" = "${var.env_prefix}-sg"
		}
  
}

## AWS LB creation 

resource "aws_lb" "myapp-lb" {
	security_groups = [aws_security_group.myapp-security-group.id]
	internal = false
	subnets = [module.subnet.myapp-subnet1_id,module.subnet.myapp-subnet2_id]
	tags = {
		"Name" = "${var.env_prefix}-lb"
		"type" = "application-${var.env_prefix}-lb"
	}	
}

## AWS LB listerner policy created 

resource "aws_lb_listener" "myapp-lb-ls" {
	load_balancer_arn = aws_lb.myapp-lb.arn
	port = "8080"
	protocol = "HTTP"
	default_action {
	  target_group_arn = aws_lb_target_group.myapp-lb-tg.arn
	  type = "forward"
	}
  
}

## AWS LB target group created 

resource "aws_lb_target_group" "myapp-lb-tg" {
	vpc_id = aws_vpc.myapp_vpc.id
	port = 8080
	protocol = "HTTP"
	name = "myapp-lb-tg"
	target_type = "instance"
}

## AWS target group attachment with Instances 

### First instance 

resource "aws_lb_target_group_attachment" "myapp-lb-tg-1a" {
	target_group_arn  = aws_lb_target_group.myapp-lb-tg.arn
	port = 8080
	target_id = aws_instance.myapp-webserver-instance-1.id
  
}

### Second instance 

resource "aws_lb_target_group_attachment" "myapp-lb-tg-2a" {
	target_group_arn  = aws_lb_target_group.myapp-lb-tg.arn
	port = 8080
	target_id = aws_instance.myapp-webserver-instance-2.id
}

## Data fetch from AWS to get the ami info being used.

data "aws_ami" "myapp-ami" {
	most_recent = true
	owners = ["amazon"]
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
	
}

## Creation of Ec2 instances {web servers with nginx container}

### First instance 

resource "aws_instance" "myapp-webserver-instance-1" {
	ami = data.aws_ami.myapp-ami.id
	instance_type = var.instance_type
	availability_zone = var.az1
	vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
	subnet_id = module.subnet.myapp-subnet1_id
	key_name = var.key_name
	associate_public_ip_address = true
	user_data = file("run-script.sh")
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

	ami = data.aws_ami.myapp-ami.id
	instance_type = var.instance_type
	availability_zone = var.az2
	vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
	subnet_id = module.subnet.myapp-subnet2_id
	key_name = var.key_name
	associate_public_ip_address = true
	user_data = file("run-script.sh")
	lifecycle {
    	create_before_destroy = true
    }

	tags = {
		"Name" = "${var.env_prefix}-webserver-instance-2"
		"role" = "${var.env_prefix}-webserver-2"
		"type" = "${var.env_prefix}-nginx-2"
	}	
}
