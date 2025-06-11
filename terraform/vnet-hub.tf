resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "appgw" {
  name                 = "appgw"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "apim" {
  name                 = "apim"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.10.1.0/25"]
}

resource "azurerm_subnet" "dns-resolver-inbound" {
  name                 = "dns-resolver-inbound"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.10.1.128/28"]
  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "dns-resolver-outbound" {
  name                 = "dns-resolver-outbound"
  resource_group_name  = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.10.1.144/28"]
  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = data.azurerm_resource_group.apim-ref-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet.id
}