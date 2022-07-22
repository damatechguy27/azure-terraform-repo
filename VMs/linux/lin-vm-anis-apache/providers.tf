terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.8"
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
   }
  }
}