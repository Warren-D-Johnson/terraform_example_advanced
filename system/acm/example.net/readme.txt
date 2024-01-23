10/25/2023

Update terraform.tfvars to have domain.
Terraform will create apex and wildcard versions for this domain.

terraform init
terraform plan
terraform apply

It will create the certificate request and add the DNS records to validate it.  The certificate request will complete successfully.
However, you will receive an error at the end:

╷
│ Error: creating Route 53 Record: InvalidChangeBatch: [Tried to create resource record set [name='_4ff54f984cd69fd8864324423d4e1238.example.net.', type='CNAME'] but it already exists]
│       status code: 400, request id: af8651be-f9d2-4403-854f-9e60eb82488c
│ 
│   with aws_route53_record.example_validation["example.net"],
│   on main.tf line 20, in resource "aws_route53_record" "example_validation":
│   20: resource "aws_route53_record" "example_validation" {
│ 
╵

That's because its actually the same CNAME record for both apex and wildcard so when the main is looping, it attempts to create the same record twice.  It doesn't effect anything.

Note: The base script creates the ACM certificate for us-east-1 and us-east-2.  If you add mroe regions to the main.tf, it will throw an error during the apply stage where it creates
the DNS records.  That can be ignored.  I tried to deal with it using conditionals but its tricky.