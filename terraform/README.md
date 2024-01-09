## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.29.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ./modules/k8s/cluster | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_node"></a> [node](#module\_node) | ./modules/k8s/node | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | ./modules/route53 | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.backend](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.frontend](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_lb.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb_hosted_zone_id.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_hosted_zone_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the resources will be created | `string` | `"production"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be created | `string` | `"us-east-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags that will be added to the resources | `map` | <pre>{<br>  "Environment": "production",<br>  "Team": "maistodos",<br>  "Terrafom": "true"<br>}</pre> | no |
| <a name="input_team"></a> [team](#input\_team) | The team that will be responsible for the resources | `string` | `"maistodos"` | no |

## Outputs

No outputs.

### Terraform Version used in this project

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | v1.1.5 |

## Architecture

![Architecture](./architecture.png)