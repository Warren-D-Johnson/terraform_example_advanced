aws_region      = "us-east-2"
sg_name         = "SSH Only"
sg_description  = "SSH Only"

ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "22.33.44.55/32"
    description = "Warren Primary"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = "55.44.33.22/32"
    description = "Warren VPN 22"
  }
]
