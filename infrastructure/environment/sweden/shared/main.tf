# random suffix
resource "random_id" "random" {
  byte_length = 4
}

#locals for rg, acr
locals {
  rg_name  = "rg-shared-se-${random_id.random.hex}"
  acr_name = "acrsharedse${random_id.random.hex}"
  sa_name  = "sasharedse${random_id.random.hex}"
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

# storage account
resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# storage account container
resource "azurerm_storage_container" "sac" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# log analytics workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.law_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

# rbac role assignment for the current user as blob data reader
resource "azurerm_role_assignment" "ra" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_client_config.current.object_id
}
