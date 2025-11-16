# Variables
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo-eks-cluster"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "865773021449"
}

# Data source to get EKS cluster info
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# IAM Policy for External Secrets Operator to access Secrets Manager
resource "aws_iam_policy" "eso_secrets_manager_policy" {
  name        = "ESO-SecretsManager-Policy"
  description = "Policy for External Secrets Operator to read from AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:prod/db-credentials*",
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:prod/redis-credentials*"
        ]
      }
    ]
  })

  tags = {
    Name        = "ESO-SecretsManager-Policy"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# IAM Role for External Secrets Operator
resource "aws_iam_role" "eso_role" {
  name = "ESO-SecretsManager-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "ESO-SecretsManager-Role"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "eso_policy_attachment" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.eso_secrets_manager_policy.arn
}

# EKS Pod Identity Association for External Secrets Operator
resource "aws_eks_pod_identity_association" "eso_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "external-secrets-system"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.eso_role.arn

  tags = {
    Name        = "ESO-PodIdentity"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}



# Outputs
output "eso_role_arn" {
  description = "ARN of the IAM role for External Secrets Operator"
  value       = aws_iam_role.eso_role.arn
}

output "eso_policy_arn" {
  description = "ARN of the IAM policy for External Secrets Operator"
  value       = aws_iam_policy.eso_secrets_manager_policy.arn
}


output "pod_identity_association_id" {
  description = "ID of the EKS Pod Identity Association"
  value       = aws_eks_pod_identity_association.eso_pod_identity.id
}
