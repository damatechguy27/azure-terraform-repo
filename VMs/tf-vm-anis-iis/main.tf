


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
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.terra_vm  
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id] # terra_nic.id
  size                  = "Standard_B2s"
#using a password  
  admin_username        = "azureuser"
  admin_password        = "Password123!"
   provision_vm_agent = true
   allow_extension_operations = true
   computer_name = "ansiblevm"
  #disable_password_authentication = false
 
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
}

resource "azurerm_virtual_machine_extension" "vmex" {
  name                 = "WINRM-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.winrm_config
  ]

  settings = <<SETTINGS
    {
      "fileUris": ["https://${azurerm_storage_account.storageTF.name}.blob.core.windows.net/datatf/winrm_setup.ps1"],
      "commandToExecute": "powershell.exe ./winrm_setup.ps1"
    }
SETTINGS
}


#Creating ansible Host.ini file 
resource "local_file" "terransifile" {

  filename = "/home/user1/cloudutils/ansible/winansible/inventory/azure-hosts2.ini"
  file_permission = "0755"
  content = <<-DOC
  [win]
  ${azurerm_windows_virtual_machine.vm.public_ip_address}
  [win:vars]
  ansible_user= ${azurerm_windows_virtual_machine.vm.admin_username} 
  ansible_password= ${azurerm_windows_virtual_machine.vm.admin_password}
  ansible_port=5986
  ansible_connection=winrm
  ansible_winrm_scheme=http
  ansible_winrm_scheme=https
  ansible_winrm_transport=credssp
  ansible_winrm_server_cert_validation=ignore
  #ansible_winrm_kerberos_delegation=true

  DOC 

  provisioner "local-exec" {
    
    command = "sleep 180; ansible-playbook -i /home/user1/cloudutils/ansible/winansible/inventory/azure-hosts2.ini /home/user1/cloudutils/ansible/winansible/playbook/iis-install.yaml"
  }
  depends_on = [
    
    azurerm_virtual_machine_extension.vmex

  ]
}
#Outputs 
output "virtual_machine_name" {
  value = azurerm_windows_virtual_machine.vm.name
  
}

output "virtual_machine_location" {
  value = azurerm_windows_virtual_machine.vm.location
  
}

output "virtual_machine_pip" {
  value = azurerm_windows_virtual_machine.vm.public_ip_address
  
}