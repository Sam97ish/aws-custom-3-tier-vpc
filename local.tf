locals {

  ipv4_cidr_blocks = { for network in module.ipv4_subnets.networks : network.name => network.cidr_block }

  ipv6_cidr_blocks = var.is_ipv6_enabled ? { for network in module.ipv6_subnets[0].networks : network.name => network.cidr_block } : {}

  subnet_details = { for sn in var.sn_details : sn.name => {
    name = sn.name,
    availability_zone = sn.availability_zone,
    is_public = sn.is_public,
    ipv4_cidr_block = lookup(local.ipv4_cidr_blocks, sn.name, null),
    ipv6_cidr_block = lookup(local.ipv6_cidr_blocks, sn.name, null)
  }}
}