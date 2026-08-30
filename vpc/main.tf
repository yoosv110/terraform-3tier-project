resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-az1"
    Tier = "public"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-az2"
    Tier = "public"
  }
}

# Application Private Subnets
resource "aws_subnet" "private_app_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_app_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-app-az1"
    Tier = "application"
  }
}

resource "aws_subnet" "private_app_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_app_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-app-az2"
    Tier = "application"
  }
}

# RDS Private Subnets
resource "aws_subnet" "private_rds_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_rds_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-rds-az1"
    Tier = "database"
  }
}

resource "aws_subnet" "private_rds_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_rds_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-rds-az2"
    Tier = "database"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway A
resource "aws_eip" "nat_az1" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip-az1"
  }
}

resource "aws_nat_gateway" "az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.environment}-nat-gw-az1"
  }
}

# NAT Gateway C
resource "aws_eip" "nat_az2" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip-az2"
  }
}

resource "aws_nat_gateway" "az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.environment}-nat-gw-az2"
  }
}

# Application Route Table - AZ1
resource "aws_route_table" "app_az1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-app-rt-az1"
  }
}

resource "aws_route" "app_az1_internet" {
  route_table_id         = aws_route_table.app_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.az1.id
}

resource "aws_route_table_association" "app_az1" {
  subnet_id      = aws_subnet.private_app_az1.id
  route_table_id = aws_route_table.app_az1.id
}

# Application Route Table - AZ2
resource "aws_route_table" "app_az2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-app-rt-az2"
  }
}

resource "aws_route" "app_az2_internet" {
  route_table_id         = aws_route_table.app_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.az2.id
}

resource "aws_route_table_association" "app_az2" {
  subnet_id      = aws_subnet.private_app_az2.id
  route_table_id = aws_route_table.app_az2.id
}

# Database Route Table
# AWS automatically creates the VPC local route.
# No 0.0.0.0/0 -> NAT/IGW route is added here.
resource "aws_route_table" "rds" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-rds-rt"
  }
}

resource "aws_route_table_association" "rds_az1" {
  subnet_id      = aws_subnet.private_rds_az1.id
  route_table_id = aws_route_table.rds.id
}

resource "aws_route_table_association" "rds_az2" {
  subnet_id      = aws_subnet.private_rds_az2.id
  route_table_id = aws_route_table.rds.id
}
