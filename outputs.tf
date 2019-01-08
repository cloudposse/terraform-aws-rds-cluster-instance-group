output "hostname" {
  value       = "${module.dns.hostname}"
  description = "The DNS address for the endpoint of the Aurora cluster"
}

output "endpoint" {
  value       = "${join("", aws_rds_cluster_endpoint.default.*.endpoint)}"
  description = "The endpoint for the Aurora cluster, automatically load-balanced across replicas"
}
