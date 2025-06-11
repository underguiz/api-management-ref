resource "azurerm_network_security_group" "apim-subnet-nsg" {
  location            = data.azurerm_resource_group.apim-ref-rg.location
  name                = "apim-hub-nsg"
  resource_group_name = data.azurerm_resource_group.apim-ref-rg.name
  
  security_rule = [{
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["443", "80"]
    direction                                  = "Inbound"
    name                                       = "lb-health-probe"
    priority                                   = 180
    protocol                                   = "*"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "AzureKeyVault"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "keyvault"
    priority                                   = 140
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "AzureMonitor"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["1886", "443"]
    direction                                  = "Outbound"
    name                                       = "monitor"
    priority                                   = 150
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "Sql"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "1433"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "sql"
    priority                                   = 130
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "Storage"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "storage"
    priority                                   = 120
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["443", "80"]
    direction                                  = "Inbound"
    name                                       = "client"
    priority                                   = 160
    protocol                                   = "Tcp"
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "traffic-manager"
    priority                                   = 170
    protocol                                   = "Tcp"
    source_address_prefix                      = "AzureTrafficManager"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "6390"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "infra-lb"
    priority                                   = 110
    protocol                                   = "Tcp"
    source_address_prefix                      = "AzureLoadBalancer"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = "Management endpoint for Azure portal and PowerShell"
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "3443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "management-endpoint"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "ApiManagement"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]

}

resource "azurerm_subnet_network_security_group_association" "apim-subnet-nsg" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.apim-subnet-nsg.id
}
