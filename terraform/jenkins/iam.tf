resource "aws_iam_role" "jenkins_pod_identity" {
  name = "JenkinsPodIdentityRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "pods.eks.amazonaws.com" 
        },
        Action = [
          "sts:AssumeRole",
          "sts:TagSession" 
        ],
        Condition = {}
      }
    ]
  })
}

# --- Data Sources for AWS Managed Policies ---
data "aws_iam_policy" "s3_full_access" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "ecr_full_access" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "iam_full_access" {
  name = "IAMFullAccess"
}

data "aws_iam_policy" "ec2_full_access" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "dynamodb_full_access" {
  name = "AmazonDynamoDBFullAccess_v2" 
}

data "aws_iam_policy" "eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "secrets_manager_read_write" {
  name = "SecretsManagerReadWrite"
}

# --- Attach Policies ---
resource "aws_iam_role_policy_attachment" "jenkins_s3" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.ecr_full_access.arn 
}

resource "aws_iam_role_policy_attachment" "jenkins_terraform" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.iam_full_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_ec2" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.ec2_full_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_dynamodb" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.dynamodb_full_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_eks" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_secrets_manager" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.secrets_manager_read_write.arn
}