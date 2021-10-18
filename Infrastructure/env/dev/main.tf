module "env" {
  source = "../../modules/env"

  environment = "Dev"
  acr_id      = var.acr_id
}