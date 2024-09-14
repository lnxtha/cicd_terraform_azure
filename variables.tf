variable "storage_account_name" {
    description = "The name of the resource group"
    type = string 
}
variable "resource_group_name" {
    description = "The name of the resource group"
    type = string 
}

variable "location" {
    description = "The location of the resource group"
    type = string
}

variable "tags" {
    description = "The tags associated with your resource"
    type = map(string)   
}

variable "source_folder_name" {
    description = "The tags associated with your resource"
    type = string   
}

variable "destination_folder_name" {
    description = "The tags associated with your resource"
    type = string   
}

variable "container_access_type" {
    description = "The tags associated with your resource"
    type = string   
}

variable "adf_name" {
    description = "The tags associated with your resource"
    type = string   
}