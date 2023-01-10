provider "aws" {
  region = "eu-central-1"
}

variable "environment" {
  description = "deployment environment"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet."
  type        = object({
    region = string
    cidr_block   = string
  })
}

resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "development-subnet" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.subnet_cidr_block.cidr_block
  availability_zone = var.subnet_cidr_block.region
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "development-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-central-1a"
}

output "vpc_id" {
  value = aws_vpc.development-vpc.id
}

