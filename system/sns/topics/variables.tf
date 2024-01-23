variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-2"
}

variable "topic_names" {
  description = "A list of topic names to be created"
  type        = list(string)
}

variable "email_endpoint" {
  description = "The email endpoint to subscribe to the SNS topics"
  type        = string
}
