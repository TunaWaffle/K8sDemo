output "app_rg" {
  value = azurerm_resource_group.app_rg
}

output "sql_server" {
  value = azurerm_mssql_server.sql_server
}