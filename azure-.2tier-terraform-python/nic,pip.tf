#PublicIp
resource "azurerm_public_ip" "public_ip" {
  name                = "MyAppVM-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgprasad.name
  allocation_method   = "Static"
}

#NIC
resource "azurerm_network_interface" "nic" {
  name                = "app-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgprasad.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}