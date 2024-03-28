# acr login name output
output "acr_login_name" {
  value = azurerm_container_registry.acr.login_server
}

# storage account name output
output "sa_name" {
  value = azurerm_storage_account.sa.name
}
