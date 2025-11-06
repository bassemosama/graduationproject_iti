resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = var.tags
  enable_dns_hostnames = true
}
