output "route_table_id" {
  value = var.public ? aws_route_table.public[0].id : aws_route_table.private[0].id
}