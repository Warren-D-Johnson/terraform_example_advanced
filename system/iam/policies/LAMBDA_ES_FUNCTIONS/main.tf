provider "aws" {
  region = var.aws_region
}

resource "aws_iam_policy" "lambda_update_policy" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:GetAccountSettings"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:InvokeFunction"
            ],
            "Resource": "arn:aws:lambda:*:*:function:es_*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/lambda/es_*",
                "arn:aws:logs:us-east-2:*:log-group::log-stream*"
            ]
        }
    ]
  })
}

output "created_policy_arn" {
  description = "The ARN of the created IAM policy"
  value       = aws_iam_policy.lambda_update_policy.arn
}
