output "mynategaway_id" {
  value       = aws_nat_gateway.nat.id
  description = "The ID of the NAT Gateway"
}