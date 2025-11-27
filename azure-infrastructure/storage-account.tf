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
