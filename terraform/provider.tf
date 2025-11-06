provider "aws" {
  shared_config_files      = ["conf"]
  shared_credentials_files = ["cred"]
  profile                  = "default"
}