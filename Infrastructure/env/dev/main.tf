module "env" {
    source = "../../modules/env"

    environment = "Dev"
    acr_name = var.acr_name
}