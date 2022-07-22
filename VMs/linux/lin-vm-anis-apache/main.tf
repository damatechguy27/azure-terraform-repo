
#Define the Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags = {
    "environment" = "dev"
    "source"      = "Terraform"
  }
}



#Define the Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.terra_vm  
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id] # terra_nic.id
  size                  = "Standard_B1s"
#using a password  
  admin_username        = "azureuser"
  disable_password_authentication = true
  
  admin_ssh_key {
    username = "azureuser"
    public_key = azurerm_ssh_public_key.terrakey.public_key
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
#letting system know that private key must be present to run
  depends_on = [
    tls_private_key.terrapriv_key
  ]

# This is to ensure SSH comes up before we run the local exec.
  
  provisioner "remote-exec" { 
    inline = ["echo 'Hello World'"]

    connection {
      type = "ssh"
      host = "${azurerm_linux_virtual_machine.vm.public_ip_address}"
      user = "azureuser"
      private_key = file(local_file.terraprivkey.filename)
    }
  }

#using ansible here add in the path to your private key on your local PC
#also the path your ansible playbook
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${azurerm_linux_virtual_machine.vm.public_ip_address}, --private-key /home/user1/Documents/terrform-sshkey/terrakey.pem /home/user1/cloudutils/ansible/playbooks/playbook-azterra-test2.yaml"

  }
  
}

#Outputs 
output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.vm.name
  
}

output "virtual_machine_location" {
  value = azurerm_linux_virtual_machine.vm.location
  
}

output "virtual_machine_pip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
  
}


output "virtual_machine_prikey" {
  sensitive = true //check true to hide the sensitive information 
  value = tls_private_key.terrapriv_key.private_key_pem
  
}