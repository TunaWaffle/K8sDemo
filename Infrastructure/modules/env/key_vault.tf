resource "azurerm_key_vault" "key_vault" {
  name                       = "demo${lower(var.environment)}${random_pet.key_vault_name.id}-kv"
  location                   = azurerm_resource_group.app_rg.location
  resource_group_name        = azurerm_resource_group.app_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization  = true
  soft_delete_retention_days = 7

  sku_name = "standard"
}

#not strictly needed in this case since the SP used in this sample has contributor on the subscription
resource "azurerm_role_assignment" "sp_key_vault_administrator" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sqlAdminUsername"
  value        = azurerm_mssql_server.sql_server.administrator_login
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sqlAdminPassword"
  value        = azurerm_mssql_server.sql_server.administrator_login_password
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "random_pet" "key_vault_name" {
  length = 1
}