
### Public IP of first instance

output "myapp-webserver-instance-1-publicIP" {
  value = aws_instance.myapp-webserver-instance-1.public_ip
}

### Public IP of second instance

output "myapp-webserver-instance-2-publicIP" {
  value = aws_instance.myapp-webserver-instance-2.public_ip
}


### AMI ID 

output "myapp-ami" {
  value = data.aws_ami.myapp-ami.id
}

output "webserver1_id" {
  value = aws_instance.myapp-webserver-instance-1.id

}

output "webserver2_id" {
  value = aws_instance.myapp-webserver-instance-2.id

}