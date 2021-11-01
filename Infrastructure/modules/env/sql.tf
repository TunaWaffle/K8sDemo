data "azuread_group" "demo_contributors" {
  display_name     = "DemoContributors"
  security_enabled = true
}

resource "azurerm_mssql_server" "sql_server" {
  name                          = "demo${lower(var.environment)}sql"
  location                      = azurerm_resource_group.app_rg.location
  resource_group_name           = azurerm_resource_group.app_rg.name
  version                       = "12.0"
  administrator_login           = random_pet.sql_admin_username.id
  administrator_login_password  = random_password.sql_admin_password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.sql_enable_public_access

  azuread_administrator {
    login_username = data.azuread_group.demo_contributors.display_name
    object_id      = data.azuread_group.demo_contributors.object_id
  }

  primary_user_assigned_identity_id = azurerm_kubernetes_cluster.app_cluster.kubelet_identity[0].user_assigned_identity_id

  identity {
    type = "UserAssigned"
    user_assigned_identity_ids = [
      azurerm_kubernetes_cluster.app_cluster.kubelet_identity[0].user_assigned_identity_id
    ]
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.app_rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_database" "app_db" {
  name         = "app-db"
  server_id    = azurerm_mssql_server.sql_server.id
  license_type = "LicenseIncluded"
  max_size_gb  = 1
  sku_name     = "Basic"

  tags = {
    Environment = var.environment
  }
}

resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
}

resource "random_pet" "sql_admin_username" {
  separator = "-"
  length    = 2
}