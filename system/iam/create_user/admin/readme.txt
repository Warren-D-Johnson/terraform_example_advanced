9/17/2023

This is for generating an administrative user ONLY.
Script will generate a password that's 25 characters in length and includes letters, numbers and symbols.
Outputs ARN of new user, password and console login URL.

terraform init
terraform plan 
terraform apply -auto-approve

When done creating user, generate the MFA for them with ./setmfa.sh
It will ask for username which in this case is 'admin'.

The token is saved into mfacodes sub-folder.

