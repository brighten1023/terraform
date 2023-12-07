# file modules/networking/output.tf
#output subnets ids
output "public_subnet_ids" {
  value = aws_subnet.public[*]
}

output "private_subnet_ids" {
  value = aws_subnet.private[*]
}

#output nat gateway ids
output "nat_gateway_id" {
  value = aws_nat_gateway.project_nat.id
}

#output vpc id
output "vpc_id" {
  value = aws_vpc.project_vpc.id
}

#output private table id
output "private_table_id" {
  value = aws_route_table.rt-private.id
}