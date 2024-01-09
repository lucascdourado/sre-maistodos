/**
 * This Terraform module creates a VPC with public and private subnets, an internet gateway,
 * a NAT gateway, route tables, and security groups.
 *
 * Resources:
 * - aws_vpc: Creates a VPC with the specified CIDR block and enables DNS support and hostnames.
 * - aws_internet_gateway: Creates an internet gateway and attaches it to the VPC.
 * - aws_eip: Creates an Elastic IP for the NAT gateway.
 * - aws_nat_gateway: Creates a NAT gateway in the public subnet and associates it with the Elastic IP.
 * - aws_subnet: Creates public and private subnets within the VPC.
 * - aws_route_table: Creates route tables for the public and private subnets.
 * - aws_route: Creates routes in the route tables to allow traffic to flow through the internet gateway and NAT gateway.
 * - aws_route_table_association: Associates the subnets with the route tables.
 * - aws_security_group: Creates a default security group for the VPC.
 *
 * Inputs:
 * - vpc_cidr: The CIDR block for the VPC.
 * - vpc_name: The name of the VPC.
 * - cluster_name: The name of the Kubernetes cluster.
 * - environment: The environment name.
 * - public_subnets_cidr: A list of CIDR blocks for the public subnets.
 * - private_subnets_cidr: A list of CIDR blocks for the private subnets.
 * - availability_zones: A list of availability zones.
 * - tags: Additional tags to apply to the resources.
 */
//VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name                                        = "${var.vpc_name}-vpc",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    Environment                                 = var.environment
  }, var.tags)
}

//Internet gateway for the public subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name        = "${var.vpc_name}-igw",
    Environment = var.environment
  }, var.tags)
}


//Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]

  tags = merge({
    Name        = "${var.vpc_name}-nat-eip",
    Environment = var.environment
  }, var.tags)
}

//NAT
resource "aws_nat_gateway" "nat" {
  count         = 1
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = merge({
    Name        = "${var.vpc_name}-${element(var.availability_zones, count.index)}-nat",
    Environment = var.environment
  }, var.tags)
}

//Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    Name                                        = "${var.vpc_name}-${element(var.availability_zones, count.index)}-public-subnet",
    Environment                                 = var.environment,
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    "kubernetes.io/role/elb"                    = 1
  }, var.tags)
}

//Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge({
    Name                                        = "${var.vpc_name}-${element(var.availability_zones, count.index)}-private-subnet",
    Environment                                 = var.environment,
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    "kubernetes.io/role/internal-elb"           = 1
  }, var.tags)
}

//Routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name        = "${var.vpc_name}-private-route-table",
    Environment = var.environment
  }, var.tags)
}

//Routing table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name        = "${var.vpc_name}-public-route-table",
    Environment = var.environment
  }, var.tags)
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

//Route table associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

//VPC's Default Security Group
resource "aws_security_group" "default" {
  name        = "${var.vpc_name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = merge({
    Name        = "${var.vpc_name}-default-sg",
    Environment = var.environment
  }, var.tags)
}
