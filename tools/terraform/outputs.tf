output "aws_ami_id" {
  value = module.myapp-webserver.aws_ami_latest.id
}

output "aws_server_1_public_ip" {
  value = module.myapp-webserver.aws_server_1.public_ip
}