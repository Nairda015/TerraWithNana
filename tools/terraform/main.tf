provider "aws" {
  region = var.region
}

variable "owner_login" { type = string }
variable "app_name" {
  default = "myapp"
  type = string
}
variable "env_prefix" { type = string }
variable "region" { type = string }
variable "avail_zone" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_cidr_block" { type = string }
variable "my_ip" { type = string }
variable "instance_type" { type = string }
variable "public_key_path" { type = string }

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-vpc"
    Owner = var.owner_login
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags              = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-subnet-1"
    Owner = var.owner_login
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-internet-gateway.id
  }
  tags   = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-rtb"
    Owner = var.owner_login
  }
}

resource "aws_internet_gateway" "myapp-internet-gateway" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags   = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-igw"
    Owner = var.owner_login
  }
}

resource "aws_route_table_association" "myapp-route-table-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-security-group" {
  name = "${var.app_name}-sg"
  vpc_id = aws_vpc.myapp-vpc.id
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
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.aws-linux-ami-latest.id
}

output "aws_server_1_public_ip" {
  value = aws_instance.myapp-server-1.public_ip
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
  
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  availability_zone = var.avail_zone
  
  associate_public_ip_address = true
  key_name = aws_key_pair.myapp-ssh-key.key_name
  
  user_data = file("entry-script.sh")
  
  tags = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-server-1"
    Owner = var.owner_login
  }
}