output "func_endpoint" {
  value = azurerm_linux_function_app.main.default_hostname
}

output "web_endpoint" {
  value = azurerm_storage_account.main.primary_web_endpoint
}

output "github_actions_secret" {
  value = {
    clientId       = azuread_service_principal.sp.client_id
    clientSecret   = azuread_application_password.password.value
    subscriptionId = data.azurerm_subscription.primary.subscription_id
    tenantId       = data.azurerm_client_config.current.tenant_id
  }
  sensitive = true
}
