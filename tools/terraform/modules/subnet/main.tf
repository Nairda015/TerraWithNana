resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags              = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-subnet-1"
    Owner = var.owner_login
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = var.vpc_id
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
  vpc_id = var.vpc_id
  tags   = {
    Name = "${var.owner_login}-${var.env_prefix}-${var.app_name}-igw"
    Owner = var.owner_login
  }
}

resource "aws_route_table_association" "myapp-route-table-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}