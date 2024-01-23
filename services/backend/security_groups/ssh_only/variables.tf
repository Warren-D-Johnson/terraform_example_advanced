variable "aws_region" {
  description = "AWS region where resources should be created."
  type        = string
}

variable "sg_name" {
  description = "Name of the security group."
  type        = string
}

variable "sg_description" {
  description = "Description of the security group."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = []
}
