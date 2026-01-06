data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "network" {
  source            = "./modules/network"
  vnet_cidr = var.vnet_cidr
  app_subnet_cidr = var.app_subnet_cidr 
  db_subnet_cidr = var.db_subnet_cidr
  project_name      = var.project_name
  location          = var.location
  resource_group_name    = data.azurerm_resource_group.rg.name
  admin_ip    = var.admin_ip
  flask_ingress_cidr = var.flask_ingress_cidr

}

module "postgres" {
  source            = "./modules/postgres"
  project_name      = var.project_name
  location          = var.location
  resource_group    = data.azurerm_resource_group.rg.name
  delegated_subnet_id = module.network.db_subnet_id
  vnet_id           = module.network.vnet_id
}

module "app_vm" {
  source              = "./modules/vm"
  project_name        = var.project_name
  location            = var.location
  resource_group = data.azurerm_resource_group.rg.name
  app_subnet_id       =  module.network.app_subnet_id
  vm_admin_username   = var.vm_admin_username
  vm_size = var.vm_size
  db_host     = module.postgres.db_fqdn
  db_name     = module.postgres.db_name
  db_user     = module.postgres.db_admin_user
  db_password = module.postgres.db_admin_password
}
