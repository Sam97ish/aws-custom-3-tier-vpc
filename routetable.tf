resource "aws_route_table" "public-rt-web" {
  vpc_id = aws_vpc.main-vpc.id

  # all traffic to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  # ipv6 traffic to the egress only internet gateway
  dynamic "route" {
    for_each = var.is_ipv6_enabled ? [1] : []
    content {
      ipv6_cidr_block = "::/0"
      gateway_id      = aws_egress_only_internet_gateway.main-egress-igw[0].id
    }
  }

  tags = {
    Name = "public-rt-web"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  for_each = { for sn in local.subnet_details : sn.name => sn if sn.is_public }

  subnet_id      = aws_subnet.vpc_subnets[each.key].id
  route_table_id = aws_route_table.public-rt-web.id
}