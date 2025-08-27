 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
    subscription_id = "bcf304d8-21b8-4358-9c77-54b5dd26f938"
}

