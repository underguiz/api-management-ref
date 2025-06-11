resource "azurerm_private_dns_zone" "api-contoso" {
  name                = "api.contoso.com"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "api-contoso" {
  name                  = "api-contoso"
  resource_group_name   = data.azurerm_resource_group.apim-ref-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.api-contoso.name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${data.azurerm_resource_group.apim-ref-rg.location}.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "aks"
  resource_group_name   = data.azurerm_resource_group.apim-ref-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_private_dns_zone" "backend" {
  name                = "backend.contoso.com"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "backend" {
  name                  = "backend"
  resource_group_name   = data.azurerm_resource_group.apim-ref-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.backend.name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault"
  resource_group_name   = data.azurerm_resource_group.apim-ref-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.hub-vnet.id
}