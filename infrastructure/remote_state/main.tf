# random suffix
resource "random_id" "random" {
  byte_length = 4
}

# locals for rg, sa and location
locals {
  rg_name  = "rg-shared-se-${random_id.random.hex}"
  sa_name  = "sasharedse${random_id.random.hex}"
  location = "swedencentral"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

# storage account
resource "azurerm_storage_account" "sa" {
  name                            = local.sa_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

# storage account container
resource "azurerm_storage_container" "sac" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
