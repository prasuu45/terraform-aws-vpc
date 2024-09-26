variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}

variable "enable_dns_hostnames" {
    default = true
  
}

variable "common_tags" {
  default = {}
}

variable "project_name" {
    type = string
  
}

variable "environment" {
    type = string
  
}
variable "vpc-tags" {
    default = {}
  
}

variable "igw_tags" {
    default = {}
  
}

variable "public-subnet_cidrs" {
    type = list
    # terraform size validation
     validation {
        condition = length(var.public-subnet_cidrs) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
     }
  
}

variable "public_subnet_tags" {
    default = {}
  
}

variable "private-subnet_cidrs" {
    type = list
    # terraform size validation
     validation {
        condition = length(var.private-subnet_cidrs) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
     }
  
}

variable "private_subnet_tags" {
    default = {}
  
}

variable "database-subnet_cidrs" {
    type = list
    # terraform size validation
     validation {
        condition = length(var.database-subnet_cidrs) == 2
        error_message = "Please provide 2 valid public subnet CIDR"
     }
  
}

variable "database_subnet_tags" {
    default = {}
  
}
variable "nat_gateway_tags" {
    default = {}
  
}

variable "public_route_table_tags" {
    default = {}
  
}
variable "private_route_table_tags" {
    default = {}
  
}

variable "database_route_table_tags" {
    default = {}
  
}

variable "is_peering_required" {
    type = bool
    default =  false 
  
}

variable "peering_tags" {
    default = {}
  
}
