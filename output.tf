## OUTPUT Info

### VPC ID 

output "myapp_vpc_id" {
    value = aws_vpc.myapp_vpc.id
  
}

### AMI ID 

output "myapp-ami" {
	value = data.aws_ami.myapp-ami.id
}

/*
output "myapp-webserver-instance-info" {
	value = aws_instance.myapp-webserver-instance.id	
}
*/

### Public IP of first instance 

output "myapp-webserver-instance-1-publicIP" {
	value = aws_instance.myapp-webserver-instance-1.public_ip
}

### Public IP of second instance

output "myapp-webserver-instance-2-publicIP" {
	value = aws_instance.myapp-webserver-instance-2.public_ip
}

output "lb-dns-name" {
  value = aws_lb.myapp-lb.dns_name
}
