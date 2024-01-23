variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "requester_vpc_id" {
  description = "The ID of the requester VPC for the peering connection."
  type        = string
}

variable "accepter_vpc_id" {
  description = "The ID of the accepter VPC for the peering connection."
  type        = string
}

variable "route_table_id" {
  description = "The ID of the route table to which a new route will be added."
  type        = string
}

variable "destination_cidr_block" {
  description = "The destination CIDR block for the new route."
  type        = string
}

variable "peering_name" {
  description = "Name and description of peering connection"
  type        = string
}
