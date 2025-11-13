//Current Azure login provide tenant_id
data "azurerm_client_config" "current" {
}

//Find current subscription and provide sybscription_id
data "azurerm_subscription" "primary" {
}

//Registers app “GitHub Actions” in that tenant 
resource "azuread_application" "git" {
  display_name = "Github Actions"
}

//Creates identity under same tenant
resource "azuread_service_principal" "sp" {
  client_id = azuread_application.git.client_id
}


data "azurerm_role_definition" "builtin" {
  name = "Contributor"
}

//Creates a client secret (password)
resource "azuread_application_password" "password" {
  application_id = azuread_application.git.id
}

//Grants Contributor role in that subscription
resource "azurerm_role_assignment" "rbac" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = data.azurerm_role_definition.builtin.name
  principal_id         = azuread_service_principal.sp.object_id
}


