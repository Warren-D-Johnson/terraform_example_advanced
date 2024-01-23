variable "aws_region" {
  default = "us-east-2"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "high_availability_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "High Availability"
  }
}

resource "aws_subnet" "high_availability_subnet_a" {
  vpc_id     = aws_vpc.high_availability_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "High Availability A"
  }
}

resource "aws_subnet" "high_availability_subnet_b" {
  vpc_id     = aws_vpc.high_availability_vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "High Availability B"
  }
}

resource "aws_subnet" "high_availability_subnet_c" {
  vpc_id     = aws_vpc.high_availability_vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "High Availability C"
  }
}

resource "aws_internet_gateway" "high_availability_igw" {
  vpc_id = aws_vpc.high_availability_vpc.id
}

data "aws_route_table" "default" {
  vpc_id = aws_vpc.high_availability_vpc.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.high_availability_subnet_a.id
  route_table_id = data.aws_route_table.default.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.high_availability_subnet_b.id
  route_table_id = data.aws_route_table.default.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.high_availability_subnet_c.id
  route_table_id = data.aws_route_table.default.id
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.high_availability_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.high_availability_igw.id
}

output "high_availability_vpc_id" {
  value = aws_vpc.high_availability_vpc.id
}

resource "null_resource" "output_to_file_high_availability" {
  triggers = {
    vpc_id = aws_vpc.high_availability_vpc.id
  }

  provisioner "local-exec" {
    command = "echo ${aws_vpc.high_availability_vpc.id} > vpcid.txt"
  }
}

resource "null_resource" "tag_default_route_table" {
  depends_on = [aws_vpc.high_availability_vpc]

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${aws_vpc.high_availability_vpc.default_route_table_id} --tags Key=Name,Value='High Availability'"
  }
}
