resource "aws_iam_role" "jenkins_pod_identity" {
  name = "JenkinsPodIdentityRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          # This is the required service principal for EKS Pod Identity
          Service = "pods.eks.amazonaws.com" 
        },
        Action = [
          # Required actions for EKS Pod Identity
          "sts:AssumeRole",
          "sts:TagSession" 
        ],
        Condition = {} # Condition block is not strictly required but can be present
      }
    ]
  })
}
# --- Data Sources for AWS Managed Policies ---
# Use the data source to fetch the correct ARN for each policy by its name.

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

# --- Attach permissions policies using the data source ARNs ---

resource "aws_iam_role_policy_attachment" "jenkins_s3" {
  role       = aws_iam_role.jenkins_pod_identity.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_pod_identity.name
  # FIX: Reference the ARN from the data source
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