provider "aws" {

  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "iti-tf-state-remote-bucket"
    key = "./terraform.tfstate" # folder/state file inside the bucket
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}