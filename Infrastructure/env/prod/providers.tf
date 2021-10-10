terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.78"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 1.0.8"
}

provider "azurerm" {
  features {}
}

provider "random" {

}
