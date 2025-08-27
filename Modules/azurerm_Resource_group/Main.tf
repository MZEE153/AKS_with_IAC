resource "azurerm_resource_group" "ResourceGroup01" {
  name     = var.resource_group_name
  location = var.rg_location
  tags = var.tags
}