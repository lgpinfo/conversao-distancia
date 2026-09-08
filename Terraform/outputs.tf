output "cluster_id" {
  value = digitalocean_kubernetes_cluster.conversao_distancia.id
}

output "cluster_name" {
  value = digitalocean_kubernetes_cluster.conversao_distancia.name
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.conversao_distancia.endpoint
}

output "kubeconfig_raw" {
  value     = digitalocean_kubernetes_cluster.conversao_distancia.kube_config[0].raw_config
  sensitive = true
}

output "db_host" {
  value = digitalocean_database_cluster.postgres.host
}

output "db_port" {
  value = digitalocean_database_cluster.postgres.port
}

output "db_user" {
  value = digitalocean_database_cluster.postgres.user
}

output "db_password" {
  value     = digitalocean_database_cluster.postgres.password
  sensitive = true
}

output "homolog_db_name" {
  value = digitalocean_database_db.homolog.name
}
