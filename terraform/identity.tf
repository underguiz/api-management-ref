resource "azurerm_user_assigned_identity" "aks-managed-identity" {
  name                = "aks-managed-identity"
  location            = data.azurerm_resource_group.apim-ref-rg.location
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
}

resource "azurerm_role_assignment" "aks-private-dns-zone" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-managed-identity.principal_id
}

resource "azurerm_role_assignment" "aks-mi-vnet" {
  scope                = azurerm_virtual_network.spoke-vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-managed-identity.principal_id
}

resource "azurerm_role_assignment" "backend-dns-zone" {
  scope                = azurerm_private_dns_zone.backend.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-backend.web_app_routing.0.web_app_routing_identity.0.object_id
}

resource "azurerm_role_assignment" "approuting-keyvault" {
    scope = azurerm_key_vault.ingress-controller-keyvault.id
    role_definition_name = "Key Vault Secrets User"
    principal_id = azurerm_kubernetes_cluster.aks-backend.web_app_routing[0].web_app_routing_identity[0].object_id
}

resource "azurerm_role_assignment" "currrent-user-keyvault" {
    scope = azurerm_key_vault.ingress-controller-keyvault.id
    role_definition_name = "Key Vault Secrets User"
    principal_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "currrent-user-keyvault-certs" {
    scope = azurerm_key_vault.ingress-controller-keyvault.id
    role_definition_name = "Key Vault Certificates Officer"
    principal_id = data.azurerm_client_config.current.object_id
}