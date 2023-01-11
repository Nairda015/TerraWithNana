resource "aws_security_group" "myapp-security-group" {
  name = "${var.app_name}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-sg"
    Owner = var.owner_login
  }
}

data "aws_ami" "aws-linux-ami-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = [var.image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "myapp-ssh-key" {
  key_name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-server-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-server-key"
    Owner = var.owner_login
  }
}

resource "aws_instance" "myapp-server-1" {
  ami = data.aws_ami.aws-linux-ami-latest.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.myapp-ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-${var.server_name}"
    Owner = var.owner_login
  }
}