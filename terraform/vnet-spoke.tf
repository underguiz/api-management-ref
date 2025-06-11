resource "azurerm_virtual_network" "spoke-vnet" {
  name                = "spoke-vnet"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location
  address_space       = ["10.11.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["10.11.0.0/24"]
}

resource "azurerm_subnet" "private-endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["10.11.1.0/25"]
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_virtual_network_dns_servers" "spoke-custom-dns" {
  virtual_network_id = azurerm_virtual_network.spoke-vnet.id
  dns_servers        = [azurerm_private_dns_resolver_inbound_endpoint.hub-dns-resolver-inbound.ip_configurations.0.private_ip_address]
}