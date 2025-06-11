resource "azurerm_private_dns_resolver" "hub-dns-resolver" {
  name                = "hub-dns-resolver"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location
  virtual_network_id  = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "hub-dns-resolver-inbound" {
  name                    = "hub-dns-resolver-inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub-dns-resolver.id
  location                = data.azurerm_resource_group.apim-ref-rg.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns-resolver-inbound.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "hub-dns-resolver-outbound" {
  name                    = "hub-dns-resolver-outbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub-dns-resolver.id
  location                = data.azurerm_resource_group.apim-ref-rg.location
  subnet_id               = azurerm_subnet.dns-resolver-outbound.id
}