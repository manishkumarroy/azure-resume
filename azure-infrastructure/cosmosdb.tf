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
