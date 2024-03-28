# random suffix
resource "random_id" "random" {
  byte_length = 4
}

# locals for rg, aca
locals {
  rg_name        = "rg-genaiapp-se-${random_id.random.hex}"
  aca_name       = "aca-genaiapp-se-${random_id.random.hex}"
  acae_name      = "acae-genaiapp-se-${random_id.random.hex}"
  location       = "swedencentral"
  containerimage = "mcr.microsoft.com/azuredocs/aci-helloworld"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

# Azure Container App Environment
resource "azurerm_container_app_environment" "acae" {
  name                       = local.acae_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

# Azure Container App
resource "azurerm_container_app" "aca" {
  name                         = local.aca_name
  container_app_environment_id = azurerm_container_app_environment.acae.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "genaiapp"
      image  = local.containerimage
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
