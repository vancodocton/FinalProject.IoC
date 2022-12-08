variable "github_token" {
  description = "Token of GitHub"
  type        = string
  sensitive   = true
}

# Azure
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  sensitive   = true
}

variable "azure_app_service_name" {
  description = "The name of the web app"
  type        = string
  sensitive   = true
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
