# --- Cluster Kubernetes ---
resource "digitalocean_kubernetes_cluster" "conversao_distancia" {
  name    = "k8s-conversao-distancia"
  region  = var.region
  version = var.cluster_version

  node_pool {
    name       = "default"
    size       = var.node_size
    node_count = var.node_count
  }
}

# --- Banco PostgreSQL gerenciado ---
resource "digitalocean_database_cluster" "postgres" {
  name       = "conversao-distancia-db"
  engine     = "pg"
  version    = "16"
  size       = var.db_size
  region     = var.region
  node_count = 1
}

# --- Banco logico de homologacao ---
resource "digitalocean_database_db" "homolog" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = var.homolog_db_name
}

# O banco "defaultdb" (usado por producao) ja vem criado
# automaticamente pela DO -- nao precisa de resource pra ele.
