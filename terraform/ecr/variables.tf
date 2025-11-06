variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether tags can be overwritten (MUTABLE or IMMUTABLE)"
  type        = string

}

variable "scan_on_push" {
  description = "Scan images for vulnerabilities on push"
  type        = bool

}

variable "ecrtags" {
  description = "Tags to assign to the repository"
  type        = map(string)
  default     = {}
}
