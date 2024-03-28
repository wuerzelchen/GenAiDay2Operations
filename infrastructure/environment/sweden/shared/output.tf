# acr login name output
output "acr_login_name" {
  value = azurerm_container_registry.acr.login_server
}

# storage account name output
output "sa_name" {
  value = azurerm_storage_account.sa.name
}

# log analytics workspace name output
output "law_name" {
  value = azurerm_log_analytics_workspace.law.name
}

# rg name output
output "law_rg_name" {
  value = azurerm_resource_group.rg.name
}
