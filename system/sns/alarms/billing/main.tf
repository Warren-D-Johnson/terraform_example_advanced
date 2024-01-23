provider "aws" {
  region = "us-east-1"
}

locals {
  topic_names = [
    "BILLING_ALERT_250_${var.identifier}",
    "BILLING_ALERT_500_${var.identifier}",
    "BILLING_ALERT_1000_${var.identifier}",
    "BILLING_ALERT_2000_${var.identifier}",
    "BILLING_ALERT_3000_${var.identifier}",
    "EMAIL_COMPLAINT_${var.identifier}"
  ]

  billing_thresholds = [250, 500, 1000, 2000, 3000]
}

resource "aws_sns_topic" "sns_topics" {
  for_each = toset(local.topic_names)
  name     = each.key
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  for_each      = aws_sns_topic.sns_topics
  topic_arn     = each.value.arn
  protocol      = "email"
  endpoint      = var.endpoint
}

resource "aws_cloudwatch_metric_alarm" "billing_alarms" {
  for_each = tomap({for t in local.billing_thresholds : "BILLING_ALERT_${t}_${var.identifier}" => t})

  alarm_name          = each.key
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"  # 6 hours
  statistic           = "Maximum"
  threshold           = each.value
  alarm_description   = "This alarm triggers when the estimated AWS charges exceed $${each.value}."
  alarm_actions       = [aws_sns_topic.sns_topics["BILLING_ALERT_${each.value}_${var.identifier}"].arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    Currency = "USD"
  }
}
