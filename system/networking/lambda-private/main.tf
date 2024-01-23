variable "aws_region" {
  default = "us-east-2"
}

provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "lambda_usage_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Lambda Usage Only"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "lambda_igw" {
  vpc_id = aws_vpc.lambda_usage_vpc.id
  tags = {
    Name = "Lambda Private Usage"
  }
}

# Create Elastic IP
resource "aws_eip" "lambda_eip" {
    tags = {
    Name = "Lambda Usage NAT"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "lambda_nat_gw" {
  subnet_id = aws_subnet.lambda_public_subnet.id
  allocation_id = aws_eip.lambda_eip.id
  depends_on = [aws_internet_gateway.lambda_igw]
}

# Create Public Subnet
resource "aws_subnet" "lambda_public_subnet" {
  vpc_id                  = aws_vpc.lambda_usage_vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "Lambda VPC Public"
  }
}

# Create Private Subnet
resource "aws_subnet" "lambda_private_subnet" {
  vpc_id     = aws_vpc.lambda_usage_vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "Lambda VPC Private"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.lambda_usage_vpc.id
    tags = {
      Name = "Lambda VPC Public Route Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lambda_igw.id
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.lambda_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.lambda_usage_vpc.id
    tags = {
      Name = "Lambda VPC Private Route Table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lambda_nat_gw.id
  depends_on             = [aws_nat_gateway.lambda_nat_gw]
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.lambda_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

output "lambda_usage_vpc_id" {
  value = aws_vpc.lambda_usage_vpc.id
}

resource "null_resource" "output_to_file" {
  triggers = {
    vpc_id = aws_vpc.lambda_usage_vpc.id
  }

  provisioner "local-exec" {
    command = "echo ${aws_vpc.lambda_usage_vpc.id} > vpcid.txt"
  }
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

resource "null_resource" "output_route_table_to_file" {
  triggers = {
    route_table_id = aws_route_table.private_route_table.id
  }

  provisioner "local-exec" {
    command = "echo ${aws_route_table.private_route_table.id} > route_table_id.txt"
  }
}

resource "null_resource" "tag_default_route_table" {
  depends_on = [aws_vpc.lambda_usage_vpc]

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${aws_vpc.lambda_usage_vpc.default_route_table_id} --tags Key=Name,Value='Lambda Usage Only'"
  }
}
