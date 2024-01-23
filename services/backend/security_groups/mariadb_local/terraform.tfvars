aws_region      = "us-east-2"
sg_name         = "MariaDB Local"
sg_description  = "MariaDB Local"
vpc_name        = "High Availability"

ingress_rules = [
  {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_block  = "10.0.0.0/8"
    description = "Local Servers"
  },
  {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_block  = "192.168.0.0/16"
    description = "Local Servers"
  }
]

