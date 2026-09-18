# --- Resource Group ---
# Na AWS nao existe esse conceito de "pasta" que agrupa tudo -- cada
# recurso vive solto na conta/regiao. Na Azure, todo recurso precisa
# pertencer a um Resource Group.
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# --- Rede: VNet + sub-rede do AKS + sub-rede delegada ao Postgres ---
# Simplificacao consciente (mesma logica das subnets publicas na AWS):
# uma unica VNet, sem hub-spoke nem NAT Gateway dedicado -- producao
# real teria uma topologia bem mais segmentada.
resource "azurerm_virtual_network" "main" {
  name                = "vnet-conversao-distancia"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "aks" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_cidr]
}

# O Postgres Flexible Server com integracao de VNet exige uma sub-rede
# so dele, delegada ao servico -- equivalente, em espirito, ao security
# group do RDS que so libera trafego vindo do cluster EKS (aqui quem
# restringe o acesso e a propria VNet, nao um SG).
resource "azurerm_subnet" "db" {
  name                 = "subnet-postgres"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_cidr]

  delegation {
    name = "postgres-delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# DNS privado exigido pelo Flexible Server quando ele vive dentro da VNet
resource "azurerm_private_dns_zone" "postgres" {
  name                = "conversao-distancia.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                   = "vnet-link-postgres"
  resource_group_name    = azurerm_resource_group.main.name
  private_dns_zone_name  = azurerm_private_dns_zone.postgres.name
  virtual_network_id     = azurerm_virtual_network.main.id
}
