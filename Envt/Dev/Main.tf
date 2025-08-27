locals {
  common_tags = {
    environment = "Dev"
    Owner       = "Azeem"
    ManagedBy   = "Terraform"
  }
}

module "rg" {
  source              = "../../Modules/azurerm_Resource_group"
  resource_group_name = "azeem-rg"
  rg_location         = "westus"
  tags                = local.common_tags
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../Modules/azurerm_Vnet"
  vnet_name           = "azeem-vnet"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

module "subnet" {
  depends_on          = [module.vnet]
  source              = "../../Modules/azurerm_Subnet"
  subnet_name         = "azeem-subnet"
  vnet_name           = module.vnet.vnet_name
  resource_group_name = module.rg.resource_group_name
  address_prefixes    = ["10.0.0.0/20"]
  tags                = local.common_tags
}

module "storageaccount" {
  depends_on          = [module.rg]
  source              = "../../Modules/azure_storage_account"
  account_name        = "azeemstorageacct"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  tags                = local.common_tags
}

module "sqlserver" {
  depends_on          = [module.rg]
  source              = "../../Modules/azurerm_sql_server"
  sql_server_name     = "azeem-sqlserver"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  admin_username      = "sqladmin"
  admin_password      = var.sql_admin_password   # 🔑 variable se lena better
  tags                = local.common_tags
}

module "sqldatabase" {
  depends_on                        = [module.sqlserver]
  source                            = "../../Modules/azurerm_SQL_Database"
  sql_server_name                   = module.sqlserver.sql_server_name
  resource_group_name               = module.rg.resource_group_name
  database_name                     = "azeem-sqldb"
  requested_service_objective_name  = "S0"
  tags                              = local.common_tags
}

module "aks" {
  depends_on          = [module.rg]
  source              = "../../Modules/azurerm_Kubernetes_cluster"
  aks_name            = "azeem-aks"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  dns_prefix          = "azeemaks"
  node_count          = 1
  vm_size             = "Standard_D2_v2"
  tags                = local.common_tags
}

module "acr" {
  depends_on          = [module.rg]
  source              = "../../Modules/azurerm_container_registry"
  acr_name            = "azeemacr"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = local.common_tags
}

module "keyvault" {
  depends_on          = [module.rg]
  source              = "../../Modules/azure_Keyvault"
  vault_name          = "azeemkv"
  resource_group_name = module.rg.resource_group_name
  rg_location         = module.rg.rg_location
  tags                = local.common_tags
}
