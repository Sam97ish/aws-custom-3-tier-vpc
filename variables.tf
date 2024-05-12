variable "aws_region" {
  description = "value of the region to deploy the resources"
  default     = "us-east-1"
}
variable "aws_profile" {
  description = "value of the profile to use"
  default     = "default"
}

variable "vpc_ip4_cidr_block" {
  description = "value of the IP4 cidr block for the vpc"
  default     = "10.16.0.0/16"
}

variable "is_ipv6_enabled" {
  description = "enables ipv6 for vpc and subnets"
  default     = true
}

variable "ipv4_subnets_new_bits" {
  description = "value of the new bits for the ipv4 subnets"
  default     = 4 # 16 subnets /20
}

variable "ipv6_subnets_new_bits" {
  description = "value of the new bits for the ipv4 subnets"
  default     = 8 # min /64
}

variable "sn_details" {
  description = "values of the subnets details for the vpc"
  type = list(object({
    name              = string
    availability_zone = string
    is_public         = bool
  }))
  default = [
    {
      name              = "sn-reserved-A-private"
      availability_zone = "us-east-1a"
      is_public         = false
    },
    {
      name              = "sn-db-A-private"
      availability_zone = "us-east-1a"
      is_public         = false
    },
    {
      name              = "sn-app-A-private"
      availability_zone = "us-east-1a"
      is_public         = false
    },
    {
      name              = "sn-web-A-public"
      availability_zone = "us-east-1a"
      is_public         = true
    },
    {
      name              = "sn-reserved-B-private"
      availability_zone = "us-east-1b"
      is_public         = false
    },
    {
      name              = "sn-db-B-private"
      availability_zone = "us-east-1b"
      is_public         = false
    },
    {
      name              = "sn-app-B-private"
      availability_zone = "us-east-1b"
      is_public         = false
    },
    {
      name              = "sn-web-B-public"
      availability_zone = "us-east-1b"
      is_public         = true
    },
    {
      name              = "sn-reserved-C-private"
      availability_zone = "us-east-1c"
      is_public         = false
    },
    {
      name              = "sn-db-C-private"
      availability_zone = "us-east-1c"
      is_public         = false
    },
    {
      name              = "sn-app-C-private"
      availability_zone = "us-east-1c"
      is_public         = false
    },
    {
      name              = "sn-web-C-public"
      availability_zone = "us-east-1c"
      is_public         = true
    }
  ]

}

variable "instance_tenancy" {
  description = "value of the instance tenancy for the vpc"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "value of the enable dns hostnames for the vpc"
  default     = true
}

variable "enable_dns_support" {
  description = "value of the enable dns support for the vpc"
  default     = true
}

variable "environment" {
  description = "value of the environment"
  default     = "dev"
}
