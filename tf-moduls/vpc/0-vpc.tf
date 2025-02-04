# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-vpc"
    }
  )
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-${element(local.availability_zones, count.index)}-public-subnet"
    }
  )
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-${element(local.availability_zones, count.index)}-private-subnet"
    }
  )
}

# Internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-igw"
    }
  )
}

# VPC Endpoint for S3
#resource "aws_vpc_endpoint" "s3" {
#  vpc_id            = aws_vpc.vpc.id
#  service_name      = "com.amazonaws.${var.aws_region}.s3"
#  route_table_ids   = [aws_route_table.private_1.id, aws_route_table.private_2.id] # Associate with both private route tables
#  vpc_endpoint_type = "Gateway"

#  policy = <<POLICY
#{
#  "Version": "2008-10-17",
#  "Statement": [
#    {
#      "Action": "*",
#      "Effect": "Allow",
#      "Resource": "*",
#      "Principal": "*"
#    }
#  ]
#}
#POLICY


#  tags = {
#    Name        = "${var.environment}-s3-vpc-endpoint"
#    Environment = var.environment
#  }
#}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-route-table"
    }
  )
}

# Routing tables to route traffic for Private Subnet 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-private-1-route-table"
    }
  )
}

# Routing tables to route traffic for Private Subnet 2
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-private-2-route-table"
    }
  )
}

# Route for Internet Gateway for Public Subnet
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Route table associations for both Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#resource "time_sleep" "wait_for_vpce" {
#  depends_on      = [aws_vpc_endpoint.s3]
#  create_duration = "480s" # Wait for 30 seconds after the VPC Endpoint creation
#}

# Route for VPC Endpoint (for S3 traffic in Private Subnet 1)
#resource "aws_route" "private_1_vpc_endpoint_s3" {
#  route_table_id         = aws_route_table.private_1.id
#  destination_cidr_block = "0.0.0.0/0"
#  vpc_endpoint_id        = aws_vpc_endpoint.s3.id
#  depends_on = [
#    time_sleep.wait_for_vpce # Wait for the VPC Endpoint to be fully available
#  ]
#}

# Route for VPC Endpoint (for S3 traffic in Private Subnet 2)
#resource "aws_route" "private_2_vpc_endpoint_s3" {
#  route_table_id         = aws_route_table.private_2.id
#  destination_cidr_block = "0.0.0.0/0"
#  vpc_endpoint_id        = aws_vpc_endpoint.s3.id
#  depends_on = [
#    time_sleep.wait_for_vpce # Wait for the VPC Endpoint to be fully available
#  ]
#}

# Route table associations for Private Subnet 1
resource "aws_route_table_association" "private_1" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, 0) # First private subnet
  route_table_id = aws_route_table.private_1.id
}

# Route table associations for Private Subnet 2
resource "aws_route_table_association" "private_2" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, 1) # Second private subnet
  route_table_id = aws_route_table.private_2.id
}
