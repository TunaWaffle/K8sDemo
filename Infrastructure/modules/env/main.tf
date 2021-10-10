resource "azurerm_resource_group" "app_rg" {
  name     = "Demo-${var.environment}"
  location = "West US"
}

resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                      = "Demo-${var.environment}-aks"
  location                  = azurerm_resource_group.app_rg.location
  resource_group_name       = azurerm_resource_group.app_rg.name
  dns_prefix                = "tunawaffles${lower(var.environment)}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}
