# random suffix
resource "random_id" "random" {
  byte_length = 4
}

#locals for rg, acr
locals {
  rg_name  = "rg-shared-se-${random_id.random.hex}"
  acr_name = "acrsharedse${random_id.random.hex}"
  law_name = "lawsharedse${random_id.random.hex}"
  location = "swedencentral"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# log analytics workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}
