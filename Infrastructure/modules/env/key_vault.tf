resource "azurerm_key_vault" "key_vault" {
  name                        = "demo${lower(var.environment)}${random_pet.key_vault_name.id}-kv"
  location                    = azurerm_resource_group.app_rg.location
  resource_group_name         = azurerm_resource_group.app_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  value        = azurerm_mssql_server.sql_server.administrator_login
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = azurerm_mssql_server.sql_server.administrator_login_password
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "random_pet" "key_vault_name" {
  length    = 1
}