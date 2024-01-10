## Terraform RDS Aurora PostgreSQL Module
### This Terraform module creates:
- RDS Cluster
- RDS Cluster Instances
- RDS Cluster Endpoints
- RDS Cluster Security Group
- RDS Cluster Autoscaling

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_endpoint) | resource |
| [aws_rds_cluster_instance.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| <a name="input_allow_minor_version_upgrade"></a> [allow\_minor\_version\_upgrade](#input\_allow\_minor\_version\_upgrade) | Indicates that minor version upgrades are allowed | `bool` | `true` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `7` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The name of the RDS cluster | `string` | n/a | yes |
| <a name="input_cluster_instances_reader"></a> [cluster\_instances\_reader](#input\_cluster\_instances\_reader) | The number of reader instances for the cluster | `number` | `1` | no |
| <a name="input_cluster_instances_writer"></a> [cluster\_instances\_writer](#input\_cluster\_instances\_writer) | The number of writer instances for the cluster | `number` | `0` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database to create when the DB instance is created | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for the master DB user | `map` | <pre>{<br>  "length": 16,<br>  "min_lower": 1,<br>  "min_numeric": 1,<br>  "min_upper": 1,<br>  "special": false<br>}</pre> | no |
| <a name="input_db_subnet_group"></a> [db\_subnet\_group](#input\_db\_subnet\_group) | A list of DB subnet group to associate with this DB instance | `list(string)` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The database engine version | `string` | `"15.3"` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A list of ingress rules to apply to the instance. | <pre>list(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `"db.t4g.medium"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Determines if performance insights is enabled | `bool` | `true` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `number` | `5432` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled | `string` | `"07:30-08:30"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range (in UTC) during which system maintenance can occur | `string` | `"mon:05:30-mon:06:30"` | no |
| <a name="input_publicly_accessible_reader"></a> [publicly\_accessible\_reader](#input\_publicly\_accessible\_reader) | Determines if cluster can be publicly accessible | `bool` | n/a | yes |
| <a name="input_publicly_accessible_writer"></a> [publicly\_accessible\_writer](#input\_publicly\_accessible\_writer) | Determines if cluster can be publicly accessible | `bool` | n/a | yes |
| <a name="input_scale"></a> [scale](#input\_scale) | The autoscaling configuration | <pre>object({<br>    max_capacity = number<br>    min_capacity = number<br>    target_value = number<br>    in_cooldown  = number<br>    out_cooldown = number<br>  })</pre> | <pre>{<br>  "in_cooldown": 300,<br>  "max_capacity": 3,<br>  "min_capacity": 1,<br>  "out_cooldown": 300,<br>  "target_value": 80<br>}</pre> | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate with the Cluster | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_endpoint"></a> [aurora\_cluster\_endpoint](#output\_aurora\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_aurora_cluster_instance_reader_endpoint"></a> [aurora\_cluster\_instance\_reader\_endpoint](#output\_aurora\_cluster\_instance\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_aurora_cluster_instance_writer_endpoint"></a> [aurora\_cluster\_instance\_writer\_endpoint](#output\_aurora\_cluster\_instance\_writer\_endpoint) | The cluster writer instance |
| <a name="output_aurora_cluster_name"></a> [aurora\_cluster\_name](#output\_aurora\_cluster\_name) | The name of the RDS cluster |
| <a name="output_aurora_cluster_port"></a> [aurora\_cluster\_port](#output\_aurora\_cluster\_port) | The cluster port |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the database |
| <a name="output_database_username"></a> [database\_username](#output\_database\_username) | The username for the database |
<!-- END_TF_DOCS -->