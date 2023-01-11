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
variable "image_name" { type = string }
variable "public_key_path" { type = string }
