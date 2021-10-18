resource "azurerm_kubernetes_cluster" "app_cluster" {
  name                = "Demo-${var.environment}-aks"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name

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

data "azurerm_resource_group" "aks_managed_resource_group" {
  name = azurerm_kubernetes_cluster.app_cluster.node_resource_group
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.app_cluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_monitoring_metrics_publisher" {
  scope                = azurerm_kubernetes_cluster.app_cluster.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.app_cluster.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = data.azurerm_resource_group.aks_managed_resource_group.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.app_cluster.identity[0].principal_id
}
