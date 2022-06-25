variable "location" {
  type = string
  description = "location provided"
}

variable "rg_name" {
  type = string
  description = "resource group name"
}

variable "vn_name" {
  type = string
  description = "virtual network name"
}

variable "sb_name" {
  type = string
  description = "subnet name" 
}

variable "nic_name" {
  type = string
  description = "network interface card name"
  
}

variable "ipname" {
  type = string
  description = "ip address name"
  
}

variable "vm_name" {

 type = string
 description = "virtual machine name"
  
}


variable "username" {
  type = string
  description = "username for windows server"
}

variable "password" {
  type = string
}