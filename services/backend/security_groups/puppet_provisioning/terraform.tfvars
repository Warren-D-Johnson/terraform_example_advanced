aws_region      = "us-east-2"
sg_name         = "Puppet Provisioning"
sg_description  = "Puppet Provisioning"
vpc_name        = "Default"

ingress_rules = [
  {
    from_port   = 8140
    to_port     = 8410
    protocol    = "tcp"
    cidr_block  = "10.0.0.0/8"
    description = "High Availability Local"
  },
  {
    from_port   = 8140
    to_port     = 8410
    protocol    = "tcp"
    cidr_block  = "172.31.0.0/16"
    description = "Default VPC Local"
  }
]
