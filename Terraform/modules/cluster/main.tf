# Création de l'adresse IP publique du cluster
resource "azurerm_public_ip" "main" {
  name                = "${var.resource_group_name}-${var.cluster_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group
  domain_name_label   = var.domain_name_label
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_role_assignment" "ra1" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "ra2" {
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_kubernetes_cluster.main.id
  depends_on           = [azurerm_kubernetes_cluster.main]
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.resource_group_name}-${var.cluster_name}"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.resource_group_name}-${var.cluster_name}"
  node_resource_group = "${var.resource_group_name}-${var.cluster_name}-node"

  default_node_pool {
    name            = var.pool_name
    node_count      = 3
    vm_size         = var.vm_size
    max_pods        = 30
    os_disk_size_gb = 100
    vnet_subnet_id  = var.subnet_id
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  identity {
    type = "SystemAssigned"
  }
}

