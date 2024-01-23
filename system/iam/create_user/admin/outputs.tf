# Output the ARN of the created IAM user
output "admin_user_arn" {
  value = aws_iam_user.admin.arn
}

output "console_login_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

