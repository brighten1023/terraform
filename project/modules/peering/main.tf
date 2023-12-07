# file modules/peering/main.tf

#create peering connection
resource "aws_vpc_peering_connection" "peer_connection" {
  peer_vpc_id = var.peer_vpc_id
  vpc_id      = var.vpc_id

  auto_accept = true
}

#create accept connection
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider        = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
  auto_accept = true
}

#create route from source to dest peer
resource "aws_route" "route" {
  route_table_id = var.source_route_table_id
  destination_cidr_block = var.dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

#create route from dest peer to source
resource "aws_route" "route_peer" {
  route_table_id = var.dest_route_table_id
  destination_cidr_block = var.source_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}