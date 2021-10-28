resource "random_pet" "sql_storage_account" {
  separator = ""
  length    = 1
}

resource "azurerm_storage_account" "sql_backup" {
  name                = "sqlbackup${random_pet.sql_storage_account.id}"
  resource_group_name = module.env.app_rg.name

  location                 = module.env.app_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
}

resource "azurerm_storage_container" "sql_backup_container" {
  name                  = "sqlbackups"
  storage_account_name  = azurerm_storage_account.sql_backup.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "delete_after_24h" {
  storage_account_id = azurerm_storage_account.sql_backup.id

  rule {
    name    = "DeleteOldBlobs"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 1
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 1
      }
      version {
        delete_after_days_since_creation = 1
      }
    }
  }
}