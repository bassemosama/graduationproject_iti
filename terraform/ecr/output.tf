output "ecr_repo_url" {
  value = aws_ecr_repository.myecr.repository_url
}

output "jenkins_ecr_role" {
  value = aws_iam_role.ecr_access_role.arn
}
output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.myecr.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.myecr.arn
}

output "ecr_role_arn" {
  description = "IAM role ARN with ECR access"
  value       = aws_iam_role.ecr_access_role.arn
}

output "ecr_policy_arn" {
  description = "IAM policy ARN for ECR access"
  value       = aws_iam_policy.ecr_access_policy.arn
}
