resource "random_string" "api-management-suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_api_management" "api-management-hub" {
  name                = "apim-hub-${random_string.api-management-suffix.result}"
  location            = data.azurerm_resource_group.apim-ref-rg.location
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  publisher_name      = "Contoso"
  publisher_email     = "contoso@contoso.com"

  sku_name             = "Premium_2"
  zones                = [1, 2]
  virtual_network_type = "Internal"
  
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }

  certificate {
    encoded_certificate = filebase64("../certs/ca.crt")
    store_name          = "Root" 
  }

  depends_on = [ azurerm_subnet_network_security_group_association.apim-subnet-nsg, ]

}

resource "azurerm_api_management_custom_domain" "production-api" {
  api_management_id = azurerm_api_management.api-management-hub.id

  gateway {
    host_name                = "production.api.contoso.com"
    certificate              = filebase64("../certs/api.contoso.com.pfx")
  }

}

resource "azurerm_private_dns_a_record" "api-management" {
  name                = "production"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  zone_name           = azurerm_private_dns_zone.api-contoso.name
  ttl                 = 300
  records             = azurerm_api_management.api-management-hub.private_ip_addresses
}