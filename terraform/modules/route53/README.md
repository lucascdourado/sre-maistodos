## This Terraform module creates:
- Route 53 Hosted Zone
- Route 53 Record Set

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | The DNS name of the ALB | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to redirect to the ALB | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The zone ID of the ALB | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The name of the created record |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the created hosted zone |

<!-- BEGIN_TF_DOCS -->
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
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.wildcard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | The DNS name of the ALB | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to redirect to the ALB | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The zone ID of the ALB | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The name of the created record |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the created hosted zone |