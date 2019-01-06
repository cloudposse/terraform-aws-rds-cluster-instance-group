output "name" {
  value       = "${join("", aws_rds_cluster.default.*.database_name)}"
  description = "Database name"
}

output "endpoint" {
  value       = "${join("", aws_rds_cluster.default.*.endpoint)}"
  description = "The DNS address of the RDS instance"
}

output "endpoint" {
  value       = "${join("", aws_rds_cluster.default.*.reader_endpoint)}"
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}
