resource "aws_s3_bucket" "test_bucket" {
  bucket = "jenkins-pipeline-test-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Jenkins Pipeline Test"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "test_bucket_versioning" {
  bucket = aws_s3_bucket.test_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_caller_identity" "current" {}