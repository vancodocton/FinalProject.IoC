# Azure Resource group
variable "resource_group_location" {
  description = "Location of the resource group."
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  sensitive   = true
}
