aws_region             = "us-east-2"
requester_vpc_id       = "vpc-11111111111111111" # Lambda Usage Only VPC id
accepter_vpc_id        = "vpc-22222222222222222" # High Availabiliy VPC id
route_table_id         = "rtb-33333333333333333" # Lambda VPC Private Route Table
destination_cidr_block = "10.0.0.0/8"
peering_name           = "Lambda Private to High Availability"
