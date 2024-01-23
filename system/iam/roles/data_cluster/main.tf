provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "data_db_cluster_role" {
  name = var.role_name
  tags = {
    "Description" = "Allows EC2 instances to call AWS services on your behalf."
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_route53_policy" {
  role       = aws_iam_role.data_db_cluster_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.policy_name}"
}

resource "aws_iam_role_policy_attachment" "mysql_backup_bucket" {
  role       = aws_iam_role.data_db_cluster_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.policy_name2}"
}

resource "aws_iam_instance_profile" "data_db_cluster_instance_profile" {
  name = var.role_name
  role = aws_iam_role.data_db_cluster_role.name
}
