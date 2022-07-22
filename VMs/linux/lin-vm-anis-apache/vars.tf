# Name of the resource group

variable "rg_name" {

  default = "terrademo"

}

# location
variable "location" {

  default = "eastus"

}

#Name of the virtual machine

variable "terra_vm" {

  default = "terraVM"

}

# Name of the Vnet
variable "terra_vnet" {

  default = "terravnet"

}

# Name of the Subnet
variable "terra_fesub" {

  default = "terrasub"

}

# Name of the public IP
variable "terra_pip" {

  default = "terrapip"

}

# Name of the NIC
variable "terra_nic" {

  default = "terranic"

}

# Name of the SG
variable "terra_sg" {

  default = "terrasg"

}

#name of SSH Key 
variable "terrakey" {
  default = "terrakey"
}
