locals {
  workflow_msi_name = "workflow-msi-${random_id.random.hex}"
  fic_subject       = "repo:${var.fic_subject_repo}:ref:refs/heads/main"
}

resource "azurerm_user_assigned_identity" "workflowmsi" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.workflow_msi_name
}

resource "azurerm_federated_identity_credential" "fic" {
  name                = "cicd-cred-${random_id.random.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.workflowmsi.id
  subject             = local.fic_subject
}
