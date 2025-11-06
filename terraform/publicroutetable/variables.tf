variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
 
}

variable "igw_id"{
    type        = string
    description = "The ID of the Internet Gateway"
}
variable "tags" {
type = map(string)

description = "Tags to apply to all resources"
}
