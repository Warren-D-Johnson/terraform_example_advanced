provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "this" {
  count = length(var.topic_names)
  name  = var.topic_names[count.index]
}

resource "aws_sns_topic_subscription" "this" {
  count                  = length(var.topic_names)
  topic_arn              = aws_sns_topic.this[count.index].arn
  protocol               = "email"
  endpoint               = var.email_endpoint
  confirmation_timeout_in_minutes = 1
}
