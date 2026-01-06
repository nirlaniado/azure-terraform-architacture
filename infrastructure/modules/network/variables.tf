variable "project_name" {
    type = string
}
variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
  
}

variable "vnet_cidr" {
    type = string
  
}
variable "app_subnet_cidr" {
    type = string
  
}
variable "db_subnet_cidr" {
    type = string
  
}
variable "admin_ip" {
    type = string
}

variable "flask_ingress_cidr" {
    type = string
  
}


