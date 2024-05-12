# AWS Custom 3-Tier VPC

AWS Custom 3-Tier VPC is a Terraform module for creating a custom 3-tier VPC on AWS. It sets up public web subnets, and private application and database subnets within a VPC. The module also manages security groups and Internet Gateway (IGW) for fine-grained control over network access and internet connectivity. It configures route tables for the public web subnets to ensure proper network traffic routing. Comprehensive tests are included to ensure the correct setup and prevent regressions. Contributions are welcome. Licensed under the MIT License.

![End State of VPC](https://github.com/acantril/aws-sa-associate-saac03/blob/main/0800-VIRTUAL_PRIVATE_CLOUD(VPC)/02_custom_vpc/vpc_endstate.png)

VPC architecture is based on [Cantrill's SAAC course](https://github.com/acantril/aws-sa-associate)
