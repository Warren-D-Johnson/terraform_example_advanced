provider "aws" {
  region = var.aws_region
}

resource "aws_iam_policy" "cloudfront_purge_policy" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Effect = "Allow"
        Resource = var.distribution_ids
      }
    ]
  })
}
