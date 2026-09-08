terraform {
  required_version = ">= 1.7"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.41"
    }
  }

  # State fica local por enquanto (terraform.tfstate, nunca commitado --
  # ver .gitignore). Em time real, isso normalmente vai pra um backend
  # remoto (Spaces da DO, Terraform Cloud).
}

provider "digitalocean" {
  token = var.do_token
}
