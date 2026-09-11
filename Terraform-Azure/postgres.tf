# --- Banco PostgreSQL gerenciado (Azure Database for PostgreSQL Flexible Server) ---
# Integrado na VNet (subnet-postgres, delegada) em vez de exposto por
# firewall/IP publico -- equivalente em intencao ao RDS, que so libera
# a porta 5432 para o security group do proprio EKS.
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-conversao-distancia"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  version    = "16"
  sku_name   = var.db_sku_name
  storage_mb = var.db_storage_mb

  administrator_login    = "psqladmin"
  administrator_password = var.db_password

  delegated_subnet_id = azurerm_subnet.db.id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  public_network_access_enabled = false

  # Sem par de zona de disponibilidade / replica standby -- mesmo
  # corte de custo do node_count fixo do RDS (sem Multi-AZ).
  zone = "1"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "defaultdb"
  server_id = azurerm_postgresql_flexible_server.main.id
}
