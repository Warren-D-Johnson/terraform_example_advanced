variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "policy_name" {
  description = "IAM Policy name"
  type        = string
}

variable "policy_description" {
  description = "IAM Policy description"
  type        = string
}

variable "security_group_id" {
  description = "ID of security Group"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}
