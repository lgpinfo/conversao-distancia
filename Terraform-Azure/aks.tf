# --- Cluster Kubernetes (AKS) ---
# Na AWS, o control plane e os nodes precisam de IAM Roles explicitas
# (ver Terraform-AWS/iam.tf). Na Azure, o AKS gerencia isso sozinho por
# tras dos panos via uma identity gerenciada -- mais proximo do modelo
# da DigitalOcean do que do da AWS.
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "conversao-distancia"
  kubernetes_version  = var.aks_version

  default_node_pool {
    name           = "default"
    vm_size        = var.node_vm_size
    node_count     = var.node_count
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  # metrics-server ja vem pre-instalado por padrao no AKS -- diferente
  # do EKS, onde precisou ser adicionado como addon explicito
  # (Terraform-AWS/eks.tf) para o HPA funcionar.
}
