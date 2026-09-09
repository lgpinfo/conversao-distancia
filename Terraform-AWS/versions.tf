terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # State fica local por enquanto -- ver .gitignore, nunca commitado
  # (guarda a senha do banco em texto puro no state).
}

provider "aws" {
  region = var.region
}
