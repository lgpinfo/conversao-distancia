terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # State fica local por enquanto -- ver .gitignore, nunca commitado
  # (guarda a senha do banco em texto puro no state).
}

provider "azurerm" {
  features {}

  # Sem subscription_id/tenant_id explicitos: usa a sessao do
  # `az login` que voce ja fez, igual o provider da AWS usa a
  # sessao do `aws configure`/SSO.
}
