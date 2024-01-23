provider "aws" {
  region = "us-east-2"
}

# Fetch Subnet IDs
data "aws_subnet" "selected" {
  count = length(var.instances)
  tags = {
    Name = var.subnet_names[var.instances[count.index]]
  }
}

# Fetch Security Group IDs
data "aws_security_group" "selected" {
  count = length(var.security_group_names)
  name  = var.security_group_names[count.index]
}

resource "aws_instance" "cluster_instance" {
  count                 = length(var.instances)
  ami                   = var.ec2_ami
  instance_type         = var.ec2_instance_type
  subnet_id             = data.aws_subnet.selected[count.index].id
  availability_zone     = var.availability_zones[var.instances[count.index]]
  iam_instance_profile  = var.iam_role
  volume_tags           = var.volume_tags[var.instances[count.index]]

  root_block_device {
    volume_type = var.root_block_device["volume_type"]
    volume_size = var.root_block_device["volume_size"]
  }

  ebs_block_device {
    device_name = "xvdf"
    volume_type = var.ebs_block_device["volume_type"]
    volume_size = var.ebs_block_device["volume_size"]
  }

  vpc_security_group_ids = [for sg in data.aws_security_group.selected : sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  disable_api_termination     = true

  credit_specification {
    cpu_credits = "unlimited"
  }

  # user_data is only used during server creation, not on subsequent boots
  user_data = <<-EOF
                #!/bin/bash
                hostnamectl set-hostname ${var.hostnames[var.instances[count.index]]}
              EOF

  tags = var.instance_tags[var.instances[count.index]]
}

