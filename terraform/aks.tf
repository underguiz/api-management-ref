resource "azurerm_kubernetes_cluster" "aks-backend" {
  name                              = "aks-backend"
  resource_group_name               = data.azurerm_resource_group.apim-ref-rg.name
  location                          = data.azurerm_resource_group.apim-ref-rg.location
  sku_tier                          = "Standard"
  private_cluster_enabled           = true
  private_dns_zone_id               = azurerm_private_dns_zone.aks.id
  dns_prefix                        = "aks-backend"
  role_based_access_control_enabled = true

  web_app_routing {
    dns_zone_ids = [azurerm_private_dns_zone.backend.id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = "Standard_D4s_v5"
    only_critical_addons_enabled = true
    node_count                   = 2
    vnet_subnet_id               = azurerm_subnet.aks.id
    zones                        = [1, 2, 3]
  }

  network_profile {
    network_plugin      = "azure"
    service_cidr        = "172.29.100.0/24"
    dns_service_ip      = "172.29.100.10"
    network_plugin_mode = "overlay"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.aks-managed-identity.id ]
  }

  lifecycle {
    ignore_changes = [
      network_profile,
      default_node_pool.0.upgrade_settings,
    ]
  }

  depends_on = [
    azurerm_role_assignment.aks-private-dns-zone,
    azurerm_role_assignment.aks-mi-vnet
  ]

}

resource "azurerm_kubernetes_cluster_node_pool" "app" {
  name                  = "app"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-backend.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 3  
  max_pods              = 250
  mode                  = "User"
  vnet_subnet_id        = azurerm_subnet.aks.id
  zones                 = [1, 2, 3]
}