output "private_route_table_id" {
  value       = aws_route_table.privatetable.id
  description = "The ID of the private subnet"
}
