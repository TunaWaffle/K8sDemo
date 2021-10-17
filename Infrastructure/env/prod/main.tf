locals {
  environment = "Prod"
}

# module "env" {
#     source = "../../modules/env"

#     environment = local.environment
#     acr_id      = azurerm_container_registry.acr.id
# }