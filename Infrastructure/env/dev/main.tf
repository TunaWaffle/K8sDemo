module "env" {
  source = "../../modules/env"

  environment = "Dev"
  acr_id      = data.azurerm_container_registry.acr.id
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = "Demo-Global"
}