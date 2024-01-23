aws_region      = "us-east-2"
sg_name         = "MariaDB Cluster Local Ports"
sg_description  = "MariaDB Cluster Local Ports"
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
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_block  = "10.0.0.0/8"
    description = "Local 4444"
  },
  {
    from_port   = 4567
    to_port     = 4567
    protocol    = "tcp"
    cidr_block  = "10.0.0.0/8"
    description = "Local 4567"
  },
  {
    from_port   = 4568
    to_port     = 4568
    protocol    = "tcp"
    cidr_block  = "10.0.0.0/8"
    description = "Local 4568"
  }
]

