variable "aws_region" {
  description = "AWS region where resources should be created."
  type        = string
}

variable "policy_arn" {
  description = "Policy we'll attach"
  type        = string
}

variable "username" {
  description = "Name of user being created"
  type        = string
}