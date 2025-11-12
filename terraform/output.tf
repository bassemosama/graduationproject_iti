# This block MUST be in your root/main directory's files
output "jenkins_role_arn_exposed" {
  description = "The final ARN needed for the EKS Pod Identity Association command."
  value       = module.jenkins.jenkins_pod_identity_role_arn 
}