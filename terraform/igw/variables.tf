variable  thevpc_id {
  type        = string
  description = "The ID of the VPC"
}
variable "tags" {
type = map(string)

description = "Tags to apply to all resources"
}