terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    container_name = "tfstate"
  }
}

provider "azurerm" {
  features {}
}
