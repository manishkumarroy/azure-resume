//azurefunction 
resource "azurerm_service_plan" "main" {
  name                = "azure-functions-cloud-resume-service-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                = "cloud-resume-visitor-counter-api"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet-isolated"
    AzureWebJobsStorage      = azurerm_storage_account.main.primary_connection_string
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    cors {
      allowed_origins = ["*"]
    }
  }
}
