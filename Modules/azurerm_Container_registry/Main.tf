resource "azurerm_container_registry" "acr01" {
  name                = "var.acr_name"
  resource_group_name = var.resource_group_name
  location            = var.rg_location
  sku                 = "Premium"
  admin_enabled       = false
  tags = var.tags
}


