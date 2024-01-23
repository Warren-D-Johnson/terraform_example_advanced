9/17/2023

Billing and SES complaint SNS topics along with their subscriptions are in us-east-1 because that is where billing and SES happens.

Modify identifier and endpoint in terraform.tfvars.

This will create SNS topics for billing and subscribe the endpoint to them.
This will create alarms for each of the thresholds and assign the corresponding SNS topics to trigger.

terraform init
terraform plan
terraform apply

