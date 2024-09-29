resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw-vpc-${aws_vpc.main-vpc.id}"
  }
}

resource "aws_egress_only_internet_gateway" "main-egress-igw" {
  count = var.is_ipv6_enabled ? 1 : 0

  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-egress-igw-vpc-${aws_vpc.main-vpc.id}"
  }
}
