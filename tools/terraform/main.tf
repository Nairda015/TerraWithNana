provider "aws" {
  region = var.region
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-vpc"
    Owner = var.owner_login
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  app_name = var.app_name
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  owner_login = var.owner_login
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-webserver" {
  source = "./modules/webserver"
  app_name = var.app_name
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  image_name = var.image_name
  instance_type = var.instance_type
  my_ip = var.my_ip
  owner_login = var.owner_login
  public_key_path = var.public_key_path
  subnet_cidr_block = var.subnet_cidr_block
  subnet_id = module.myapp-subnet.subnet.id
  vpc_id = aws_vpc.myapp-vpc.id
  server_name = "server-1"
}