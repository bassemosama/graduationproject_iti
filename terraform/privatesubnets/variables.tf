
variable "tags" {
type = map(string)

description = "Tags to apply to all resources"
}
variable "vpc_id"{
    type        = string
    description = "The ID of the VPC"
}
variable "subnet-cidr"{
    type        = string
    description = "The CIDR block for the subnet"
}
variable "azs" {
  type    = string
  description = "A list of availability zones"
}