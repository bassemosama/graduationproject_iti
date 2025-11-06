variable "cluster_name" {
    type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "eks_version" {

    type = string
}
