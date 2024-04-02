# acr login name output
# storage account name output
output "sa_name" {
  value = azurerm_storage_account.sa.name
}

# resource group name output
output "rg_name" {
  value = azurerm_resource_group.rg.name
}
