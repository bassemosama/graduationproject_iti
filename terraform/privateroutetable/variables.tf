variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
 
}
variable "natgateway_id"{
    type        = string
    description = "The ID of the NAT Gateway"
}

variable "tags" {
type = map(string)

description = "Tags to apply to all resources"
}
