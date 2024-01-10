output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets_id" {
  description = "The ID list of the public subnet"
  value       = aws_subnet.public_subnet.*.id
}

output "private_subnets_id" {
  description = "The ID list of the private subnet"
  value       = aws_subnet.private_subnet.*.id
}

output "public_subnets_cidr_block" {
  description = "The CIDR block list of the public subnet"
  value       = aws_subnet.public_subnet.*.cidr_block
}

output "private_subnets_cidr_block" {
  description = "The CIDR block list of the private subnet"
  value       = aws_subnet.private_subnet.*.cidr_block
}

output "default_sg_id" {
  description = "The ID of the default security group"
  value       = aws_security_group.default.id
}

output "security_groups_ids" {
  description = "The ID list of the security groups"
  value       = ["${aws_security_group.default.id}"]
}

output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway"
  value       = aws_internet_gateway.ig.id
}
