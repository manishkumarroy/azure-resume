resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}








# test-trigger
# test-trigger
# test-trigger
# test-trigger
# test-trigger
//test
//test-trigger
