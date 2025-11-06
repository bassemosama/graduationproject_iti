
output "public_route_table_id" {
  value       = aws_route_table.publicroutetable.id
  description = "The ID of the public route table"
}