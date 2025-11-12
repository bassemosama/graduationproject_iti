output "jenkins_pod_identity_role_arn" {
  description = "The ARN of the IAM role for Jenkins Pod Identity."
  value       = aws_iam_role.jenkins_pod_identity.arn
}