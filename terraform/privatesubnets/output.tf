output "privatesubnet_id" {
  value       = aws_subnet.privatesubnet.id
  description = "The ID of the private subnet"
}