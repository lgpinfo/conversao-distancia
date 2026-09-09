variable "region" {
  description = "Regiao da AWS"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-conversao-distancia"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_type" {
  description = "Tipo de instancia EC2 para os nodes do EKS"
  type        = string
  default     = "t3.medium"
}

variable "node_count" {
  description = "Quantos nodes no node group"
  type        = number
  default     = 2
}

variable "eks_version" {
  description = "Versao do Kubernetes no EKS. Confirme as disponiveis com: aws eks describe-addon-versions --query 'addons[0].addonVersions[0].compatibilities[].clusterVersion' (ou no console EKS ao criar)"
  type        = string
  default     = "1.31"
}

variable "db_instance_class" {
  description = "Classe da instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_password" {
  description = "Senha do usuario master do RDS -- AWS NAO gera sozinha, ao contrario da DO. Nunca commitar -- passar via TF_VAR_db_password."
  type        = string
  sensitive   = true
}
