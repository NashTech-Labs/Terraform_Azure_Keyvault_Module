terraform {
  # backend "remote" {
  #   workspaces {
  #     prefix = "WS-" 
  #   }
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.21.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # tenant_id       = var.azure_tenant_id
  # subscription_id = var.azure_subscription_id
  # client_id       = var.azure_client_id
  # client_secret   = var.azure_client_secret
}