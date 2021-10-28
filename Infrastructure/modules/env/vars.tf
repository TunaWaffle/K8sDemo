variable "environment" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "sql_enable_public_access" {
  type    = bool
  default = false
}