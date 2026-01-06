resource "random_password" "db" {
  length  = 24
  special = true
}

locals {
  db_admin_user = "pgadmin"
  db_name       = "app-db"
}

resource "azurerm_private_dns_zone" "pg" {
  name                = "private.postgres.database.azure.com"
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "pg_link" {
  name                  = "pg-dns-link-${var.project_name}"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.pg.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_postgresql_flexible_server" "pg" {
  name                = "pg-${var.project_name}"
  resource_group_name = var.resource_group
  location            = var.location

  version = "16"

  administrator_login    = local.db_admin_user
  administrator_password = random_password.db.result

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.pg.id

  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = local.db_name
  server_id = azurerm_postgresql_flexible_server.pg.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
