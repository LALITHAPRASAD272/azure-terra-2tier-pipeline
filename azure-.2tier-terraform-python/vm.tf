#Virtual_Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "MyAppVM"
  resource_group_name = azurerm_resource_group.rgprasad.name
  location            = var.location
  size                = "Standard_D2s_v3"

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "null_resource" "app_deploy" {

  depends_on = [
    azurerm_linux_virtual_machine.vm,
    azurerm_mysql_flexible_server.mysql
  ]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.vm.public_ip_address
  }

  # ✅ Copy app files
  provisioner "file" {
    source      = "app/"
    destination = "/home/${var.admin_username}/"
  }

  provisioner "remote-exec" {
    inline = [

      # ---------------- INSTALL ----------------
      "sudo apt update -y",
      "sudo apt install -y python3-pip ca-certificates mysql-client",

      # ✅ Install globally (fixes gunicorn + systemd issues)
      "sudo pip3 install flask flask-sqlalchemy pymysql gunicorn",

      # ---------------- CREATE DB (SAFE) ----------------
      # (ignore error if already exists)
 "mysql -h ${azurerm_mysql_flexible_server.mysql.fqdn} -u ${var.mysql_admin} -p${var.mysql_password} --ssl-mode=REQUIRED -e \"CREATE DATABASE IF NOT EXISTS studentdb;\"",
      # ---------------- SYSTEMD SERVICE ----------------
      "sudo bash -c 'cat > /etc/systemd/system/flaskapp.service <<EOF\n[Unit]\nDescription=Flask App\nAfter=network.target\n\n[Service]\nUser=${var.admin_username}\nWorkingDirectory=/home/${var.admin_username}\n\n# ✅ FIX PATH (important)\nEnvironment=\"PATH=/usr/local/bin:/usr/bin:/bin\"\n\n# ✅ DB ENV (with Azure MySQL)\nEnvironment=DB_HOST=${azurerm_mysql_flexible_server.mysql.fqdn}\nEnvironment=DB_USER=${var.mysql_admin}\nEnvironment=DB_PASSWORD=${var.mysql_password}\nEnvironment=DB_NAME=studentdb\n\n# ✅ Gunicorn (global install)\nExecStart=/usr/local/bin/gunicorn -w 2 -b 0.0.0.0:5000 app:app\n\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\nEOF'",

      # ---------------- RESTART APP ----------------
      "sudo systemctl daemon-reload",
      "sudo systemctl enable flaskapp",
      "sudo systemctl restart flaskapp"
    ]
  }
}