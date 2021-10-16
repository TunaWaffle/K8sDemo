data "azuread_group" "demo_contributors" {
  display_name     = "DemoContributors"
  security_enabled = true
}

# This is only being done to facilitate adding in a common group of contributors in Azure on the main subscription
resource "azurerm_role_assignment" "demo_contributors" {
  scope                = var.scope
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.demo_contributors.object_id
}

