module "env" {
  source = "../../modules/env"

  acr_id                   = var.acr_id
  environment              = "Dev"
  sql_enable_public_access = true
}