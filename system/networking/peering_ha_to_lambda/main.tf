provider "aws" {
  region = var.aws_region
}

resource "aws_vpc_peering_connection" "example" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = true

  tags = {
    Name = var.peering_name
    Description = var.peering_name
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}


resource "aws_route" "example" {
  depends_on = [aws_vpc_peering_connection.example]

  route_table_id            = var.route_table_id
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.example.id
}
