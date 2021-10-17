locals {
  environment = "Prod"
}

# module "env" {
#     source = "../../modules/env"

#     environment = local.environment
#     acr_name = azurerm_container_registry.acr.name
# }