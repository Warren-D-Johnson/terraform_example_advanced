11/1/2023

Creates "Puppet Provisioning" Security Group in us-east-2.
Adds default outbound rule.
Adds inbound on port 8140 along 10.0.0.0/8 for servers on the HA VPC and 8140 along 172.31.0.0/16 for Default VPC.

Individual rules have description set, but Terraform has no way of setting the "Name" on the individual rule.