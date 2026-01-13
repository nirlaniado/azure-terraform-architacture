resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.project_name}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.project_name}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipcfg"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_app" {
  name                = "vm-app-${var.project_name}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.ssh.public_key_openssh
  }


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

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    db_host          = var.db_host
    db_name          = var.db_name
    db_user          = var.db_user
    db_password      = var.db_password
    db_sslmode       = var.db_sslmode
    app_py           = file("${path.module}/../../../app/app.py")
    db_py            = file("${path.module}/../../../app/db.py")
    requirements_txt = file("${path.module}/../../../app/requirements.txt")
  }))
}


