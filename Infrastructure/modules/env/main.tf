resource "azurerm_resource_group" "app_rg" {
  name     = "Demo-${var.environment}"
  location = "West US"
  tags = {
    Environment = var.environment
  }
}

module "app_rg_demo_contributors" {
  source = "../demo_contributors"

  scope = azurerm_resource_group.app_rg.id
}
