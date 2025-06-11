resource "azurerm_public_ip" "application-gateway" {
  name                = "application-gateway-pip"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location
  allocation_method   = "Static"
  zones               = [ 1, 2, 3 ]
}

resource "azurerm_application_gateway" "public-apis-appgw" {
  name                = "public-apis-appgw"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  location            = data.azurerm_resource_group.apim-ref-rg.location

  zones = [ 1, 2, 3 ]

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  ssl_certificate {
    name = "api.contoso.com"
    data = filebase64("../certs/api.contoso.com.pfx")
  }

  trusted_root_certificate {
    name = "contoso"
    data = filebase64("../certs/ca.crt")
  }

  gateway_ip_configuration {
    name      = "ipconfig"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = "frontend-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "application-gateway-pip"
    public_ip_address_id = azurerm_public_ip.application-gateway.id
  }

  backend_address_pool {
    name = "api-management"
    fqdns = ["production.api.contoso.com"]
  }

  backend_http_settings {
    host_name                     = "production.api.contoso.com"
    name                           = "api-management-http-settings"
    cookie_based_affinity         = "Disabled"
    path                           = "/"
    port                           = 443
    protocol                       = "Https"
    request_timeout                = 60
    trusted_root_certificate_names = [ "contoso"]
    probe_name                     = "api-management-probe"
  }

  probe {
    host                = "production.api.contoso.com"
    name                = "api-management-probe"
    protocol            = "Https"
    path                = "/status-0123456789abcdef"
    timeout             = 120
    interval            = 10
    unhealthy_threshold = 3
    match {
      status_code = [ "200-399" ]
    }
  }

  http_listener {
    host_name                      = "production.api.contoso.com"
    name                           = "public-apis-listener"
    frontend_ip_configuration_name = "application-gateway-pip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Https"
    ssl_certificate_name           = "api.contoso.com" 
  }

  request_routing_rule {
    name                       = "public-apis-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "public-apis-listener"
    backend_address_pool_name  = "api-management"
    backend_http_settings_name = "api-management-http-settings"
    priority                   = "1" 
  }
}