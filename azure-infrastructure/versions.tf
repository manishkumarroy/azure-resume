terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
    backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "st7g86plzhe9"
    container_name       = "tfstate"
    key                  = "azure-resume"

  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "aeee5554-d721-4ee7-a599-b71bc3b4f693"
}
