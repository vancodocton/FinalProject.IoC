variable "github_token" {
  description = "Token of GitHub"
  type        = string
  sensitive   = true
}

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

# GitHub
variable "gh_repo_full_name" {
  type        = string
  description = "The fullname of GitHub repository"
  sensitive   = true
}

variable "gh_repo_deployment_branch" {
  type        = string
  description = "The name of branch for deployment"
  sensitive   = true
}

variable "gh_azure_app_service_secret_name" {
  description = "The name of the web app"
  type        = string
  sensitive   = true
}

variable "gh_azure_publish_profile_secret_name" {
  description = "The key of Azure publish profile"
  type        = string
  sensitive   = true
}

variable "gh_environment_name" {
  type        = string
  description = "The deployment environment name"
}
