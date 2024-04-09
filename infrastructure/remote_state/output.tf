# acr login name output
# storage account name output
output "sa_name" {
  value = azurerm_storage_account.sa.name
}

# resource group name output
output "rg_name" {
  value = azurerm_resource_group.rg.name
}

# user assigned identity client id output
output "ua_identity_client_id" {
  value = azurerm_user_assigned_identity.workflowmsi.client_id
}

# user assigned identity tenant id output
output "ua_identity_tenant_id" {
  value = azurerm_user_assigned_identity.workflowmsi.tenant_id
}

# subscription id output
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
