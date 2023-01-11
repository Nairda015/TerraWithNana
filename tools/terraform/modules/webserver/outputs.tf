output "aws_ami_latest" {
  value = data.aws_ami.aws-linux-ami-latest
}

output "aws_server_1" {
  value = aws_instance.myapp-server-1
}