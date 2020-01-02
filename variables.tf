variable "resource_group_name" {  
  description = "Azure Lab Resource Group Name"
  default = "RG_marcelnguyen_20191230"
}

variable "location" {
  description = "Azure Lab Resource Group Location"
  default = "southeastasia"
}

variable "vm_size" {
    description = "Azure Lab VM Size"
    default = "Standard_DS1_v2"
}