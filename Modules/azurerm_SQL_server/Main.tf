resource "azurerm_mssql_server" "SQL Server01" {
  name                         = "mssqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.rg_location
  version                      = "12.0"
  administrator_login          = "var.admin_login"
  administrator_login_password = "var.admin_password"
  minimum_tls_version          = "1.2"
  tags = var.tags
}


