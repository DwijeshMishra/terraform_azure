# Configure the Azure provider
terraform {
  backend "azurerm" {
    resource_group_name  = "AzureBackupRG_centralus_1"
    storage_account_name = "terraformdwijesh"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vn" {
  name = var.vn_name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "sb" {
   name = var.sb_name
   resource_group_name = azurerm_resource_group.rg.name
   address_prefixes = [ "10.0.0.0/24" ]
   virtual_network_name = azurerm_virtual_network.vn.name
}

resource "azurerm_network_interface" "internal" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sb.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
    name = var.vm_name
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    admin_username = var.username
    admin_password = var.password
 
    network_interface_ids = [
    azurerm_network_interface.internal.id
  ]
    os_disk {
     
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    } 
  
    source_image_reference {
      publisher = "MicrosoftwindowsServer"
      offer = "windowsServer"
      sku = "2016-DataCenter"
      version = "latest"
    }
}
