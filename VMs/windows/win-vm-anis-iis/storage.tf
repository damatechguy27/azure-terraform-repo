#Creatng the storage account to hold the Powershell Script
resource "azurerm_storage_account" "storageTF"{
  name = var.terrastorage
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  account_kind = "Storage"
  account_tier = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_container" "datatf" {
  name = "datatf"
  storage_account_name = azurerm_storage_account.storageTF.name
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.storageTF
  ]
  
}

resource "azurerm_storage_blob" "winrm_config" {
  name = "winrm_setup.ps1"
  storage_account_name = azurerm_storage_account.storageTF.name
  storage_container_name = azurerm_storage_container.datatf.name
  type = "Block"
  source = "winrm_setup.ps1"
    depends_on = [
      azurerm_storage_container.datatf
    ]
  
}
