provider "aws" {
  region = "us-east-1"
}

locals {
  generated_password = "pwgen -sy 25 1"
}

resource "aws_iam_user" "admin" {
  name = var.user_name
  path = "/"
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "null_resource" "set_password" {
  triggers = {
    # Add a trigger that depends on a unique value, such as a timestamp so it runs every time
    run_provisioner = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      PASSWORD=$( ${local.generated_password} )
      aws iam create-login-profile --user-name ${aws_iam_user.admin.name} --password $PASSWORD --no-password-reset-required > output.log 2>&1
      echo "Generated password for ${aws_iam_user.admin.name}: $PASSWORD"
    EOT
  }

  depends_on = [aws_iam_user.admin, aws_iam_user_policy_attachment.admin]
}
