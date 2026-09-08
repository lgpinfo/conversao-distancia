variable "do_token" {
  description = "Personal Access Token da DigitalOcean, com escopo de Kubernetes + Databases. Nunca commitar -- passar via TF_VAR_do_token."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Regiao da DO -- precisa suportar Managed Database (nyc1 funciona, atl1 nao)"
  type        = string
  default     = "nyc1"
}

variable "cluster_version" {
  description = "Versao do Kubernetes. Confirme as disponiveis com: doctl kubernetes options versions"
  type        = string
  default     = "1.36.3-do.3"
}

variable "node_size" {
  description = "Tamanho de cada node do cluster"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "node_count" {
  description = "Quantos nodes no pool -- ja comecamos com 3 (licao aprendida: 2 nao sobra espaco pro Prometheus/Grafana)"
  type        = number
  default     = 3
}

variable "db_size" {
  description = "Tamanho do droplet do banco gerenciado"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "homolog_db_name" {
  description = "Nome do banco logico de homologacao dentro do cluster de banco"
  type        = string
  default     = "conversao_homolog"
}
