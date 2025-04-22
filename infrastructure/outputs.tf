/* app runner */

output "apprunner_service_url" {
  value = aws_apprunner_service.bashkim_cms.service_url
}

/* ecr */

output "ecr_repository_url" {
  value = aws_ecr_repository.bashkim_cms.repository_url
}

/* database (aurora) */

output "db_host" {
  value = aws_rds_cluster.bashkim_cms.endpoint
}

output "db_username" {
  value = var.db_username
}

output "db_name" {
  value = var.db_name
}
