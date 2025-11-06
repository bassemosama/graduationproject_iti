resource "aws_internet_gateway" "myigw" {
    vpc_id = var.thevpc_id
    tags = {
    Name = "myigw"
    }
}