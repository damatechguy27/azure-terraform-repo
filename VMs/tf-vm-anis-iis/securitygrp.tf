#Defining a Security Group 
resource "azurerm_network_security_group" "terraweb" {
  name                = var.terra_sg
  location            = azurerm_resource_group.rg.location #getting location of VM location 
  resource_group_name = azurerm_resource_group.rg.name #rg will be the resource group name
  # security rule 1 opening port https
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "https443"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }
  # security rule 2 opening port http
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http80"
    priority                   = 101
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }

  # security rule 3 opening port ssh
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "RDP-3389"
    priority                   = 102
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "3389"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }

  # security rule 4 opening port WinRM HTTP
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "winrm-http"
    priority                   = 103
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "5985"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }

  # security rule 5 opening port WinRM HTTPS
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "winrm-https"
    priority                   = 104
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "5986"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }

  # security rule 6 opening port 22
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 105
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.nic.private_ip_address #setting destination to vm private IP 
  }
}

resource "azurerm_network_interface_security_group_association" "terrasg" {
  network_interface_id      = azurerm_network_interface.nic.id # setting interface to the Private IP of vm NIC 
  network_security_group_id = azurerm_network_security_group.terraweb.id # setting the name of the SG to the web server 
}
