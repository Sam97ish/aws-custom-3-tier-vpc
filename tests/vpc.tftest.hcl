variables {
    environment = "test"
    aws_region = "us-east-1"
}

run "unit_tests_for_vpc_module" {
    command = plan

    assert {
        condition = aws_vpc.main-vpc.cidr_block == var.vpc_ip4_cidr_block
        error_message = "vpc cidr block is not the same as the one defined in the variables"
    }

    assert {
        condition = length(aws_route_table_association.public-subnet-association) == length([for sn in var.sn_details : sn if sn.is_public])
        error_message = "number of public subnet rt associations is not equal to the number of public subnets"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.internet_to_web_tls.from_port == 443 && aws_vpc_security_group_ingress_rule.internet_to_web_tls.to_port == 443
        error_message = "web security group does not have the correct ingress rule from internet for tls"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.internet_to_web_ssh.from_port == 22 && aws_vpc_security_group_ingress_rule.internet_to_web_ssh.to_port == 22
        error_message = "web security group does not have the correct ingress rule from internet for ssh"
    }

    assert {
        condition = aws_vpc_security_group_egress_rule.web_to_app_tls.from_port == 443 && aws_vpc_security_group_egress_rule.web_to_app_tls.to_port == 443
        error_message = "web security group does not have the correct egress rule to app for tls"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.web_to_app_tls.from_port == 443 && aws_vpc_security_group_ingress_rule.web_to_app_tls.to_port == 443
        error_message = "app security group does not have the correct ingress rule from web for tls"
    }

    assert {
        condition = aws_vpc_security_group_egress_rule.app_to_db_tls.from_port == 1433 && aws_vpc_security_group_egress_rule.app_to_db_tls.to_port == 27017
        error_message = "app security group does not have the correct egress rule to db for tls"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.app_to_db_tls.from_port == 0 && aws_vpc_security_group_ingress_rule.app_to_db_tls.to_port == 65535
        error_message = "db security group does not have the correct ingress rule from app for tls"
    }

}

run "input_validation" {
    command = plan

    # invalid values
    variables {
        vpc_ip4_cidr_block = "6564546"
        sn_details = []
        is_ipv6_enabled = "yes"
        ipv4_subnets_new_bits = "no"
        ipv6_subnets_new_bits = "uhh"
        enable_dns_support = "yes"
        enable_dns_hostnames = "yes"
    }

    expect_failures = [
        var.vpc_ip4_cidr_block,
        var.sn_details,
        var.is_ipv6_enabled,
        var.ipv4_subnets_new_bits,
        var.ipv6_subnets_new_bits,
        var.enable_dns_support,
        var.enable_dns_hostnames
    ]
}

run "e2e_tests" {
    command = apply

    assert {
        condition = alltrue([for sn in var.sn_details : aws_route_table_association.public-subnet-association[sn.name].subnet_id != aws_subnet.vpc_subnets[sn.name].id if !sn.is_public])
        error_message = "non public subnets are associated with the public route table"
    }

    assert {
        condition = aws_security_group.web_sg.vpc_id == aws_vpc.main-vpc.id
        error_message = "web security group is not associated with the vpc"
    }

    assert {
        condition = aws_security_group.app_sg.vpc_id == aws_vpc.main-vpc.id
        error_message = "app security group is not associated with the vpc"
    }

    assert {
        condition = aws_security_group.db_sg.vpc_id == aws_vpc.main-vpc.id
        error_message = "db security group is not associated with the vpc"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.app_to_db_tls.referenced_security_group_id == aws_security_group.app_sg.id
        error_message = "db security group does not have the correct app security group referenced for tls"
    }

    assert {
        condition = aws_vpc_security_group_ingress_rule.web_to_app_tls.referenced_security_group_id == aws_security_group.web_sg.id
        error_message = "app security group does not have the correct web security group referenced for tls"
    }

    assert {
        condition = aws_vpc_security_group_egress_rule.web_to_app_tls.referenced_security_group_id == aws_security_group.app_sg.id
        error_message = "web security group does not have the correct app security group referenced for tls"
    }

    assert {
        condition = aws_vpc_security_group_egress_rule.app_to_db_tls.referenced_security_group_id == aws_security_group.db_sg.id
        error_message = "app security group does not have the correct db security group referenced for tls"
    }

}