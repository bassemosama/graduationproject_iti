variable "public_subnet_id"{
    type        = string
    description = "The ID of the public subnet"
}
variable "tags" {
type = map(string)

description = "Tags to apply to all resources"
}