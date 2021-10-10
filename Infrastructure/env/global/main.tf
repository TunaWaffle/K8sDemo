resource "azurerm_resource_group" "global_rg" {
  name     = "Demo-Global"
  location = "WestUS"
  tags     = {
    Environment = "global"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "democr"
  resource_group_name = azurerm_resource_group.global_rg.name
  location            = azurerm_resource_group.global_rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    Environment = "global"
  }
}