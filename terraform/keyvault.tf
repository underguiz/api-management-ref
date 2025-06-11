resource "random_string" "ingress-controller-keyvault" {
  length           = 5
  special          = false
}

resource "azurerm_key_vault" "ingress-controller-keyvault" {
  name                = "ingress-controller-${random_string.ingress-controller-keyvault.result}"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                  = "standard"
  enable_rbac_authorization = true

}

resource "azurerm_private_endpoint" "ingress-controller-keyvault" {
  name                = "ingress-controller-keyvault"
  location            = data.azurerm_resource_group.apim-ref-rg.location
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "keyvault"
    private_connection_resource_id = azurerm_key_vault.ingress-controller-keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }
}

resource "azurerm_key_vault_certificate" "backend" {
  name         = "backend-contoso-com"
  key_vault_id = azurerm_key_vault.ingress-controller-keyvault.id

  certificate {
    contents = filebase64("../certs/backend.contoso.com.pfx")
  }
}