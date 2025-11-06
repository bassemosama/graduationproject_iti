output "subnet_id" {
  value       = aws_subnet.publicsubnet.id
  description = "The ID of the public subnet"
}