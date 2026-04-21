#azurerm_mysql_flexible_server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "prasaddatabase12345unique"
  resource_group_name    = azurerm_resource_group.rgprasad.name
  location               = "koreacentral"

  administrator_login    = var.mysql_admin
  administrator_password = var.mysql_password

  sku_name = "B_Standard_B1ms"
  version  = "8.0.21"

  storage {
    size_gb = 20
  }
}

#azurerm_mysql_flexible_server_firewall_rule
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_vm" {
  name                = "Allow-VM-IP"
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = azurerm_resource_group.rgprasad.name

  start_ip_address = azurerm_public_ip.public_ip.ip_address
  end_ip_address   = azurerm_public_ip.public_ip.ip_address

  depends_on = [
    azurerm_public_ip.public_ip,
    azurerm_mysql_flexible_server.mysql
  ]
}