

resource "aws_iam_role" "secret_manager_role" {
  name = "${var.secret_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"  # بدل secretsmanager.amazonaws.com
      }
    }]
  })
}


resource "aws_iam_policy" "secret_manager_policy" {
  name        = "${var.secret_name}-policy"
  description = "Policy to allow EKS pods to access the secret"

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
        Resource = aws_secretsmanager_secret.mysecret.arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_secret_policy" {
  role       = aws_iam_role.secret_manager_role.name
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}


resource "aws_secretsmanager_secret" "mysecret" {
  name        = var.secret_name
  description = var.secret_description
}


resource "aws_secretsmanager_secret_version" "mysecret_version" {
  secret_id     = aws_secretsmanager_secret.mysecret.id
  secret_string = jsonencode(var.secret_values)
}



