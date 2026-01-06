output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}

output "db_admin_user" {
  value = azurerm_postgresql_flexible_server.pg.administrator_login
}

output "db_admin_password" {
  value     = random_password.db.result
  sensitive = true
}
