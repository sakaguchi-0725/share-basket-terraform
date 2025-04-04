provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "../../modules/vpc"
  name                 = "share-basket-dev"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "bastion" {
  source        = "../../modules/bastion"
  name          = "dev"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  allowed_ips   = var.bastion_allow_ips
  ami_id        = data.aws_ami.amazon_linux.id
  key_name      = var.bastion_key_name
  instance_type = "t3.micro"
}

module "control-plane" {
  source         = "../../modules/kubernetes_ec2"
  name           = "dev"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.private_subnet_ids[0]
  ami_id         = data.aws_ami.ubuntu.id
  key_name       = var.k8s_key_name
  instance_type  = "t3.medium"
  bastion_sg_id  = module.bastion.bastion_sg_id
}

