variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Name of the application"
}

variable "zone_id" {
  type        = "string"
  default     = ""
  description = "Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas"
}

variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnets" {
  type        = "list"
  description = "List of VPC subnet IDs"
}

variable "instance_type" {
  type        = "string"
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = "string"
  default     = "2"
  description = "Number of DB instances to create in the cluster"
}

variable "db_port" {
  type        = "string"
  default     = "3306"
  description = "Database port"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = ["replicas"]
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "cluster_parameters" {
  type        = "list"
  default     = []
  description = "List of DB parameters to apply"
}

variable "instance_parameters" {
  type        = "list"
  default     = []
  description = "List of DB instance parameters to apply"
}

variable "allowed_cidr_blocks" {
  type        = "list"
  default     = []
  description = "List of CIDR blocks allowed to access"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "publicly_accessible" {
  description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
  default     = "false"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode`"
  default     = "true"
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = "true"
}

variable "rds_monitoring_interval" {
  description = "Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60)"
  default     = "0"
}

variable "rds_monitoring_role_arn" {
  type        = "string"
  default     = ""
  description = "The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs"
}
