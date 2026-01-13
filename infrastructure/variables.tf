variable "resource_group_name" {
  type    = string
  default = "rg-nir"
}

variable "project_name" {
  type    = string
  default = "simple-net-app"

}
variable "location" {
  type    = string
  default = "uksouth"
}

variable "flask_ingress_cidr" {
  type    = string
  default = "0.0.0.0/0"

}


variable "admin_ip" {
  type    = string
  default = "77.124.79.165/32"

}

variable "app_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}


variable "db_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}
variable "vm_admin_username" {
  type    = string
  default = "azureuser"
}
