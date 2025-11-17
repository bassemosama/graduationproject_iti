variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"

}
variable "tags" {
  type = map(string)
  default = {
    terraform  = "true"
    kubernetes = "demo-eks-cluster"
  }
  description = "Tags to apply to all resources"
}
variable "subnet-cidr" {
  type        = list(string)
  description = "The CIDR block for the subnet"

}
variable "privatesubnet-cidr" {
  type        = list(string)
  description = "The CIDR block for the subnet"

}
variable "azs" {
  type = list(string)

}

variable "eks_version" {
  type        = string
  default     = "1.34"
  description = "EKS version"
}

variable "cluster_name" {
  type        = string
  default     = "demo-eks-cluster"
  description = "value of the EKS cluster name"

}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "ourrepo"
}

variable "image_tag_mutability" {
  description = "Whether tags can be overwritten (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Scan images for vulnerabilities on push"
  type        = bool
  default     = true
}

variable "ecrtags" {
  description = "Tags to assign to the repository"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "EKS-CI"
  }
}
variable "db_secret_name" {
  description = "Name of the DB secret"
  type        = string
}

variable "db_secret_description" {
  description = "Description of DB secret"
  type        = string
}

variable "db_secret_values" {
  description = "DB credentials map"
  type        = map(string)
}


variable "redis_secret_name" {
  description = "Name of the Redis secret"
  type        = string
}

variable "redis_secret_description" {
  description = "Description of Redis secret"
  type        = string
}

variable "redis_secret_values" {
  description = "Redis connection map"
  type        = map(string)
}
#test pipline 7
