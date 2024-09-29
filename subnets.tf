module "ipv4_subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vpc_ip4_cidr_block

  networks = [
    for sn in var.sn_details : {
      name     = sn.name
      new_bits = var.ipv4_subnets_new_bits
    }
  ]
}

module "ipv6_subnets" {
  count = var.is_ipv6_enabled ? 1 : 0

  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = aws_vpc.main-vpc.ipv6_cidr_block

  networks = [
    for sn in var.sn_details : {
      name     = sn.name
      new_bits = var.ipv6_subnets_new_bits
    }
  ]
}
