terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.6.0"
    }
  }
}

provider "vault" {
  # Configuration options
  address = "http://127.0.0.1:8202"
  token   = var.vault1-token
}