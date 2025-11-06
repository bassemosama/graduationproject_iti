resource "aws_subnet" "publicsubnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet-cidr
  availability_zone       = var.azs
  map_public_ip_on_launch = true
  tags                    = var.tags
}
