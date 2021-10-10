terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.78"
    }
  }

  required_version = ">= 1.0.8"
}

provider "azurerm" {
  features {}
}
