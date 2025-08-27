locals {
  Common_tags = {
    environment = "Dev"
    Owner      = "Azeem"
    ManagedBy   = "Terraform"
  }
}

module "rg" {
  source              = "../Modules/azurerm_Resource_group"
  resource_group_name = "azeem-RG"
  rg_location         = "west US"
  tags = local.Common_tags
}

module "vnet" {
    depends_on = [ module.rg ]
    source              = "../Modules/azurerm_Vnet"
    vnet_name           = "azeem-vnet"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    address_space       = ["9.0.0.0/16"]
    tags = local.Common_tags
}

module "subnet" {
    depends_on = [ module.vnet ]
    source              = "../Modules/azurerm_Subnet"
    subnet_name         = "azeem-subnet"
    vnet_name           = module.vnet.vnet_name
    resource_group_name = module.rg.resource_group_name
    address_prefixes    = ["9.0.0.0/20"]
    tags = local.Common_tags
}

module "storageaccount" {
    depends_on = [ module.rg ]
    source              = "../Modules/azure_storage_account"
    account_name        = "azeemstorageacct"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    tags = local.Common_tags
}


module "sqlserver" {
    depends_on = [ module.rg ]
    source              = "../Modules/azurerm_sql_server"
    sql_server_name    = "azeem-sqlserver"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    admin_username      = "sqladmin"
    admin_password      = "Azeem@12345"
    tags = local.Common_tags
}

module "sql database" {
    depends_on = [ module.sqlserver ]
    source              = "../Modules/azurerm_sql_database"
    sql_server_name     = module.sqlserver.sql_server_name
    resource_group_name = module.rg.resource_group_name
    database_name       = "azeem-sqldb"
    requested_service_objective_name = "S0"
    tags = local.Common_tags
  
}

module "aks" {
    depends_on = [ module.rg ]
    source              = "../Modules/azurerm_Kubnertes_cluster"
    aks_name            = "azeem-aks"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    dns_prefix          = "azeemaks"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    tags = local.Common_tags
}

module "ACR" {
    depends_on = [ module.rg ]
    source              = "../Modules/azurerm_container_registry"
    acr_name            = "azeemacr"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    sku                 = "Basic"
    admin_enabled       = true
    tags = local.Common_tags
}

module "keyvault" {
    depends_on = [ module.rg ]
    source              = "../Modules/azure_Keyvault"
    vault_name          = "azeemkv"
    resource_group_name = module.rg.resource_group_name
    rg_location         = module.rg.rg_location
    tags = local.Common_tags
}