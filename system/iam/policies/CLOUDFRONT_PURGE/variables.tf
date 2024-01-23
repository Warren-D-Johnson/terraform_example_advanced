variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "distribution_ids" {
  description = "List of CloudFront distribution IDs to be purged"
  type        = list(string)
}

variable "policy_name" {
  description = "IAM Policy name"
  type        = string
}

variable "policy_description" {
  description = "IAM Policy description"
  type        = string
}
