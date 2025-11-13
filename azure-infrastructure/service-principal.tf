data "azurerm_subscription" "primary" {
}

data "azurerm_role_definition" "builtin" {
  name = "Contributor"
}

data "azurerm_client_config" "current" {
}

resource "azuread_application" "git" {
  display_name = "Github Actions"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.git.client_id
}

resource "azuread_application_password" "password" {
  application_id = azuread_application.git.id
}

resource "azurerm_role_assignment" "rbac" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = data.azurerm_role_definition.builtin.name
  principal_id         = azuread_service_principal.sp.object_id
}


