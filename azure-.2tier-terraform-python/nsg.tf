#NSG
resource "azurerm_network_security_group" "app_nsg" {
  name                = "Appnsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgprasad.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
  }

  security_rule {
    name                       = "Allow-flask"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
  }
}
#NSG_Assosiate
resource "azurerm_network_interface_security_group_association" "assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}