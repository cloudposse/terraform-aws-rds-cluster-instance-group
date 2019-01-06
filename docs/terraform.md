## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_cidr_blocks | List of CIDR blocks allowed to access | list | `<list>` | no |
| apply_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | string | `true` | no |
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| cluster_family | The family of the DB cluster parameter group | string | `aurora5.6` | no |
| cluster_identifier | The cluster identifier | string | - | yes |
| cluster_parameters | List of DB parameters to apply | list | `<list>` | no |
| cluster_size | Number of DB instances to create in the cluster | string | `2` | no |
| custom_endpoint_type | The type of the endpoint. One of: READER, ANY. | string | `READER` | no |
| db_port | Database port | string | `3306` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| instance_parameters | List of DB instance parameters to apply | list | `<list>` | no |
| instance_type | Instance type to use | string | `db.t2.small` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| promotion_tier | Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoter to writer. | string | `1000` | no |
| publicly_accessible | Set to true if you want your cluster to be publicly accessible (such as via QuickSight) | string | `false` | no |
| rds_monitoring_interval | Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60) | string | `0` | no |
| rds_monitoring_role_arn | The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs | string | `` | no |
| security_group_ids | The IDs of the security groups from which to allow `ingress` traffic to the DB instance | list | `<list>` | no |
| security_groups | List of security groups to be allowed to connect to the DB instance | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| storage_encrypted | Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode` | string | `true` | no |
| subnets | List of VPC subnet IDs | list | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| vpc_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | string | - | yes |
| zone_id | Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | The endpoint for the Aurora cluster, automatically load-balanced across replicas |
| hostname | The DNS address for this endpoint |

