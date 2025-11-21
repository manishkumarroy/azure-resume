resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}

resource "azurerm_cosmosdb_account" "db" {
  name                = "tfex-cosmos-db-${var.application_name}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableTable"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "BoundedStaleness"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

}

resource "azurerm_cosmosdb_table" "table" {
  name                = "tfex-cosmos-table-${var.application_name}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.db.name
}

//Storage account for azure function
resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_account_static_website" "frontend" {
  storage_account_id = azurerm_storage_account.main.id
  index_document     = "index.html"
  //ror_404_document = "custom_not_found.html"
}


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

# test-trigger
# test-trigger
# test-trigger
# test-trigger
# test-trigger
//test
//test-trigger
