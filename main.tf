resource "aws_vpc" "main-vpc" {
  cidr_block                       = var.vpc_ip4_cidr_block
  assign_generated_ipv6_cidr_block = var.is_ipv6_enabled
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "vpc_subnets" {
  for_each = { for sn in local.subnet_details : sn.name => sn }

  cidr_block = each.value.ipv4_cidr_block
  ipv6_cidr_block = var.is_ipv6_enabled ? each.value.ipv6_cidr_block : null

  vpc_id                          = aws_vpc.main-vpc.id
  availability_zone               = each.value.availability_zone
  assign_ipv6_address_on_creation = var.is_ipv6_enabled
  map_public_ip_on_launch         = each.value.is_public

  tags = {
    Name   = each.value.name
    Public = tostring(each.value.is_public)
  }
}
