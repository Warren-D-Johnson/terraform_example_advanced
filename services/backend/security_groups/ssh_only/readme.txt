10/25/2023

Creates "SSH Only" Security Group in us-east-2.
Adds default outbound rule.
Adds inbound on port 22 to Warren and Warren's VPN.

Individual rules have description set, but Terraform has no way of setting the "Name" on the individual rule. I can't even see those "Name" (Which aren't tags btw)
with AWS CLI describe-security-groups.
