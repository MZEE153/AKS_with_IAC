resource "azurerm_storage_account" "storageaccount01" {
  name                     = "var.account_name"
  resource_group_name      = var.resource_group_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = var.tags 
}

