#adding keypairs 

#creating private key
resource "tls_private_key" "terrapriv_key" {
  algorithm = "RSA"
  rsa_bits = 4096
  
}

#saving private key as a local file using a different name here
#add here path to where you want to save your private key
resource "local_file" "terraprivkey" {
  filename = "/home/user1/Documents/terrform-sshkey/terrakey.pem"
  file_permission = "0600"
  content = tls_private_key.terrapriv_key.private_key_pem  
}

#creating the public key using the private key file created 
resource "azurerm_ssh_public_key" "terrakey" {
  name                = "vm-terra-key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = tls_private_key.terrapriv_key.public_key_openssh
}
