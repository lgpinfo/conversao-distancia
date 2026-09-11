variable "resource_group_name" {
  description = "Nome do Resource Group que agrupa todos os recursos"
  type        = string
  default     = "rg-conversao-distancia"
}

variable "location" {
  description = "Regiao da Azure"
  type        = string
  default     = "brazilsouth"
}

variable "cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "aks-conversao-distancia"
}

variable "vnet_cidr" {
  description = "Bloco CIDR da VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "Sub-rede onde os nodes do AKS ficam"
  type        = string
  default     = "10.1.0.0/20"
}

variable "db_subnet_cidr" {
  description = "Sub-rede delegada ao Postgres Flexible Server (precisa de delegation, por isso fica separada da sub-rede do AKS)"
  type        = string
  default     = "10.1.16.0/24"
}

variable "node_vm_size" {
  description = "SKU da VM de cada node do AKS -- equivalente ao t3.medium usado no EKS (burstable, 2 vCPU/4GB)"
  type        = string
  default     = "Standard_B2s"
}

variable "node_count" {
  description = "Quantos nodes no node pool"
  type        = number
  default     = 2
}

variable "aks_version" {
  description = "Versao do Kubernetes no AKS. Confirme as disponiveis com: az aks get-versions --location <location> -o table"
  type        = string
  default     = "1.31"
}

variable "db_sku_name" {
  description = "SKU do Postgres Flexible Server -- equivalente ao db.t3.micro usado no RDS (burstable, 1 vCPU)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "db_storage_mb" {
  description = "Storage do Flexible Server -- 32768 (32GB) e o minimo permitido, nao da pra ir tao enxuto quanto os 20GB do RDS"
  type        = number
  default     = 32768
}

variable "db_password" {
  description = "Senha do usuario administrador do Postgres -- Azure NAO gera sozinha, igual a AWS. Nunca commitar -- passar via TF_VAR_db_password."
  type        = string
  sensitive   = true
}
