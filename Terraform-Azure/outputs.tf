output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "region" {
  value = var.location
}

output "db_host" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "db_port" {
  value = 5432
}

output "db_user" {
  value = azurerm_postgresql_flexible_server.main.administrator_login
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.app.name
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
