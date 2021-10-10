resource "azurerm_resource_group" "app_rg" {
  name     = "Demo-${var.environment}"
  location = "West US"
  tags     = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                      = "Demo-${var.environment}-aks"
  location                  = azurerm_resource_group.app_rg.location
  resource_group_name       = azurerm_resource_group.app_rg.name

  api_server_authorized_ip_ranges = []
  dns_prefix                      = "tunawaffles${lower(var.environment)}"

  default_node_pool {
    availability_zones = []
    name               = "default"
    node_count         = 1
    node_taints        = []
    tags               = {}
    vm_size            = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}
