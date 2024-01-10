## This Terraform module creates:
- VPC 
- Public Subnetes
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups

This Terraform module creates a VPC with public and private subnets, an internet gateway,
a NAT gateway, route tables, and security groups.

Resources:
- aws\_vpc: Creates a VPC with the specified CIDR block and enables DNS support and hostnames.
- aws\_internet\_gateway: Creates an internet gateway and attaches it to the VPC.
- aws\_eip: Creates an Elastic IP for the NAT gateway.
- aws\_nat\_gateway: Creates a NAT gateway in the public subnet and associates it with the Elastic IP.
- aws\_subnet: Creates public and private subnets within the VPC.
- aws\_route\_table: Creates route tables for the public and private subnets.
- aws\_route: Creates routes in the route tables to allow traffic to flow through the internet gateway and NAT gateway.
- aws\_route\_table\_association: Associates the subnets with the route tables.
- aws\_security\_group: Creates a default security group for the VPC.

Inputs:
- vpc\_cidr: The CIDR block for the VPC.
- vpc\_name: The name of the VPC.
- cluster\_name: The name of the Kubernetes cluster.
- environment: The environment name.
- public\_subnets\_cidr: A list of CIDR blocks for the public subnets.
- private\_subnets\_cidr: A list of CIDR blocks for the private subnets.
- availability\_zones: A list of availability zones.
- tags: Additional tags to apply to the resources.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The az that the resources will be launched | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment | `string` | n/a | yes |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | The CIDR block for the private subnet | `list(string)` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | The CIDR block for the public subnet | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to launch the bastion host | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block of the vpc | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_sg_id"></a> [default\_sg\_id](#output\_default\_sg\_id) | The ID of the default security group |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the created Internet Gateway |
| <a name="output_private_subnets_cidr_block"></a> [private\_subnets\_cidr\_block](#output\_private\_subnets\_cidr\_block) | The CIDR block list of the private subnet |
| <a name="output_private_subnets_id"></a> [private\_subnets\_id](#output\_private\_subnets\_id) | The ID list of the private subnet |
| <a name="output_public_subnets_cidr_block"></a> [public\_subnets\_cidr\_block](#output\_public\_subnets\_cidr\_block) | The CIDR block list of the public subnet |
| <a name="output_public_subnets_id"></a> [public\_subnets\_id](#output\_public\_subnets\_id) | The ID list of the public subnet |
| <a name="output_security_groups_ids"></a> [security\_groups\_ids](#output\_security\_groups\_ids) | The ID list of the security groups |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->