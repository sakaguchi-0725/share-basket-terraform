variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "allowed_ips" {
  type    = list(string)
  default = ["0.0.0.0/0"] # セキュリティ重視なら自IPのみ推奨
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
  description = "Name of the SSH key pair"
}
