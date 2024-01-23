provider "aws" {
  region = var.environments[var.environment].region
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.environments[var.environment].vpc_name_tag]
  }
}

data "aws_subnet" "selected" {
  count = length(var.environments[var.environment].subnet_tags)

  filter {
    name   = "tag:Name"
    values = [var.environments[var.environment].subnet_tags[count.index]]
  }

  depends_on = [data.aws_vpc.selected]
}

data "aws_security_group" "efs_to_origin" {
  filter {
    name   = "tag:Name"
    values = [var.environments[var.environment].sg_efs_to_origin]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_efs_file_system" "example" {
  creation_token = var.environments[var.environment].creation_token

  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  tags = {
    Name = var.environments[var.environment].creation_token
  }
}

resource "aws_efs_mount_target" "example" {
  count           = length(data.aws_subnet.selected.*.id)
  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = data.aws_subnet.selected.*.id[count.index]
  security_groups = [data.aws_security_group.efs_to_origin.id]
}

resource "aws_efs_access_point" "default" {
  file_system_id = aws_efs_file_system.example.id

  tags = {
    Name = var.environments[var.environment].efs_access_point
  }
}
