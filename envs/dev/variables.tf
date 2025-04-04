variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  type    = string
}

variable "public_subnet_cidrs" {
  type    = list(string)
}

variable "private_subnet_cidrs" {
  type    = list(string)
}

variable "azs" {
  type    = list(string)
}

variable "k8s_key_name" {
  type = string
}

variable "bastion_key_name" {
  type = string
}

variable "bastion_allow_ips" {
  type = list(string)
}
