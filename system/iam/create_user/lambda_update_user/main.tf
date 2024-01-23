provider "aws" {
  region = var.aws_region
}

resource "aws_iam_user" "lambda_update_user" {
  name = var.username
}

resource "aws_iam_user_policy_attachment" "lambda_update_user_policy_attach" {
  user       = aws_iam_user.lambda_update_user.name
  policy_arn = var.policy_arn 
}

resource "aws_iam_access_key" "lambda_update_user_key" {
  user = aws_iam_user.lambda_update_user.name
}

output "access_key_id" {
  value     = aws_iam_access_key.lambda_update_user_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.lambda_update_user_key.secret
  sensitive = true
}
