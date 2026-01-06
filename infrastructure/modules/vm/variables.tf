variable "project_name" { 
    type = string 
    }

variable "location"     { 
    type = string 
    }

variable "resource_group" { 
    type = string 
    }

variable "app_subnet_id" { 
    type = string 
    }

variable "vm_size" {
    type = string
  
}

variable "vm_admin_username" {
     type = string 
     }



variable "db_host" { 
    type = string 
    }

variable "db_name" { 
    type = string 
    }

variable "db_user" { 
    type = string 
    }

variable "db_password" { 
type = string 
sensitive = true 
}

variable "db_sslmode" {
  type    = string
  default = "require"
}
