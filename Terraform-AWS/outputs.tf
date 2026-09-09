output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "region" {
  value = var.region
}

output "db_host" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_user" {
  value = aws_db_instance.postgres.username
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
