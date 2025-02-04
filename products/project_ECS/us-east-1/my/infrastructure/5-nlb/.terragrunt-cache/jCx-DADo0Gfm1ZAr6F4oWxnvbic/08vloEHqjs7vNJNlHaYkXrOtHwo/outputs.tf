output "aws_vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "aws_internet_gateway_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.ig.id
}

#output "aws_vpc_endpoint_id" {
#  description = "The VPC Endpoint ID"
#  value       = aws_vpc_endpoint.s3.id
#}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = aws_subnet.public_subnet[*].id
}

output "public_subnets_cidr" {
  description = "List of public subnets CIDR blocks"
  value       = var.public_subnets_cidr
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = aws_subnet.private_subnet[*].id
}
