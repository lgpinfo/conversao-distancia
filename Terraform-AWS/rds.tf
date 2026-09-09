# --- Banco PostgreSQL gerenciado (RDS) ---

resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-conversao-distancia"
  subnet_ids = aws_subnet.public[*].id
}

# Libera a porta do Postgres so para o security group que o proprio
# EKS ja cria automaticamente para o cluster (nao para a internet
# inteira -- diferente de simplesmente abrir 0.0.0.0/0).
resource "aws_security_group" "rds" {
  name   = "rds-conversao-distancia"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.main.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "conversao-distancia-db"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  db_name                 = "defaultdb"
  username                = "postgres"
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  depends_on = [aws_eks_node_group.main]
}
