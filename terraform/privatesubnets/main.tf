resource "aws_subnet" "privatesubnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet-cidr
  
  map_public_ip_on_launch = false
  availability_zone       = var.azs
  tags                    = var.tags
}