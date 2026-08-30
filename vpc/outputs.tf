output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]
}

output "private_app_subnet_ids" {
  value = [
    aws_subnet.private_app_az1.id,
    aws_subnet.private_app_az2.id
  ]
}

output "private_rds_subnet_ids" {
  value = [
    aws_subnet.private_rds_az1.id,
    aws_subnet.private_rds_az2.id
  ]
}

output "nat_gateway_ids" {
  value = [
    aws_nat_gateway.az1.id,
    aws_nat_gateway.az2.id
  ]
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "app_route_table_ids" {
  value = [
    aws_route_table.app_az1.id,
    aws_route_table.app_az2.id
  ]
}

output "rds_route_table_id" {
  value = aws_route_table.rds.id
}
