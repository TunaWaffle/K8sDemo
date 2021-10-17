resource "azurerm_resource_group" "global_rg" {
  name     = "Demo-Global"
  location = "WestUS"
  tags = {
    Environment = local.environment
  }
}

module "global_rg_demo_contributors" {
  source = "../../modules/demo_contributors"

  scope = azurerm_resource_group.global_rg.id
}

resource "random_pet" "cr_name" {
  keepers = {
    rg = azurerm_resource_group.global_rg.id
  }
  separator = ""
  length    = 1
}

resource "azurerm_container_registry" "acr" {
  name                = "demo${random_pet.cr_name.id}cr"
  resource_group_name = azurerm_resource_group.global_rg.name
  location            = azurerm_resource_group.global_rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    Environment = local.environment
  }
}