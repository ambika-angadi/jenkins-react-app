resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnets_cidr
  availability_zone       = var.availability_zones
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "TF Subnet ${var.availability_zones}"
  }
}