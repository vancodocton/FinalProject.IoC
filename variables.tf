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

# Azure PostgreSql Flexible Server
variable "POSTGRES_SERVER_ADMINISTRATOR_LOGIN" {
  description = "Postgre Server Administrator Username"
  sensitive   = true
  type        = string
}

variable "azurerm_service_plan_sku_name" {
  description = "SKU of the resource group."
  type        = string
}

variable "IDSV_IDENTITY_DB_CONNECTION_STRING_NAME" {
  description = "Connection string to PosgreSql Database for Identity Server"
  type        = string
}
