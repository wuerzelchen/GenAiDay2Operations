locals {
  workflow_msi_name = "workflow-msi-${random_id.random.hex}"
  # this is the subject of the federated identity credential, it is the repo and the branch that the token is scoped to
  fic_subject = "repo:${var.fic_subject_repo}:ref:refs/heads/main"
}

resource "azurerm_user_assigned_identity" "workflowmsi" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.workflow_msi_name
}

# This defines the federated identity credential that will be used to authenticate to the Azure AD Token Exchange endpoint, in our case relevant for github actions to authenticate via oauth2
resource "azurerm_federated_identity_credential" "fic" {
  name                = "cicd-cred-${random_id.random.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.workflowmsi.id
  subject             = local.fic_subject
}

resource "azurerm_role_assignment" "example" {
  # this sets the scope to the subscription level
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  # this sets the principal to the user assigned identity which gets the contributor role to the subscription(scope)
  principal_id = azurerm_user_assigned_identity.workflowmsi.principal_id
}
