#Define a virtual network and subnet Creating a terraform CIDR of new VNET 
resource "azurerm_virtual_network" "vnet" {
  name = var.terra_vnet
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name = var.terra_fesub
  resource_group_name =  azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.10.0/24"]
}


#Define a new public IP address
resource "azurerm_public_ip" "publicip" {
  name = var.terra_pip
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
  sku = "Basic"
}

#Define a Network Interface for our VM also is the private IP

resource "azurerm_network_interface" "nic" {
  name = var.terra_nic
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "ipconfig1"
    subnet_id = azurerm_subnet.subnet.id # terra_fesub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}



