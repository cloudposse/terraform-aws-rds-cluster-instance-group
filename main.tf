module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.5"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

locals {
  enabled = "${var.enabled == "true"}"
}

resource "aws_security_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${module.label.id}"
  description = "Allow inbound traffic from Security Groups and CIDRs"
  vpc_id      = "${var.vpc_id}"

  tags = "${module.label.tags}"
}

locals {
  security_group_id = "${join("", aws_security_group.default.*.id)}"
}

resource "aws_security_group_rule" "allow_ingress" {
  count                    = "${local.enabled ? length(var.security_group_ids) : 0}"
  security_group_id        = "${local.security_group_id}"
  type                     = "ingress"
  from_port                = "${var.db_port}"
  to_port                  = "${var.db_port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.security_group_ids[count.index]}"
}

resource "aws_security_group_rule" "allow_ingress_cidr" {
  count             = "${local.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0}"
  security_group_id = "${local.security_group_id}"
  type              = "ingress"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.allowed_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_egress" {
  count             = "${local.enabled ? 1 : 0}"
  security_group_id = "${local.security_group_id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_rds_cluster_instance" "default" {
  count                   = "${local.enabled ? var.cluster_size : 0}"
  identifier              = "${module.label.id}-${count.index+1}"
  cluster_identifier      = "${aws_rds_cluster.default.id}"
  instance_class          = "${var.instance_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"
  db_parameter_group_name = "${aws_db_parameter_group.default.name}"
  publicly_accessible     = "${var.publicly_accessible}"
  tags                    = "${module.label.tags}"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  monitoring_interval     = "${var.rds_monitoring_interval}"
  monitoring_role_arn     = "${var.rds_monitoring_role_arn}"
}

resource "aws_db_subnet_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${module.label.id}"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = ["${var.subnets}"]
  tags        = "${module.label.tags}"
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${module.label.id}"
  description = "DB cluster parameter group"
  family      = "${var.cluster_family}"
  parameter   = ["${var.cluster_parameters}"]
  tags        = "${module.label.tags}"
}

resource "aws_db_parameter_group" "default" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${module.label.id}"
  description = "DB instance parameter group"
  family      = "${var.cluster_family}"
  parameter   = ["${var.instance_parameters}"]
  tags        = "${module.label.tags}"
}

resource "aws_rds_cluster_endpoint" "default" {
  count                       = "${local.enabled ? 1 : 0}"
  cluster_identifier          = "${aws_rds_cluster.default.id}"
  cluster_endpoint_identifier = "reader"
  custom_endpoint_type        = "READER"

  static_members = "${aws_rds_cluster_instance.default.*.id}"
}

module "dns_replicas" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.5"
  enabled   = "${var.enabled == "true" && length(var.zone_id) > 0 ? "true" : "false"}"
  namespace = "${var.namespace}"
  name      = "${join(".", list(module.label.attributes, var.name))}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${coalescelist(aws_rds_cluster_endpoint.default.*.endpoint, list(""))}"]
}