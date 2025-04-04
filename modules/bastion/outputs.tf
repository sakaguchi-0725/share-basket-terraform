output "bastion_public_ip" {
  value = aws_eip.this.public_ip
}

output "bastion_id" {
  value = aws_instance.this.id
}

output "bastion_sg_id" {
  value = aws_security_group.this.id
}

