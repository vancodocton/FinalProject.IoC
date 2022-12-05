
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  sensitive   = true
}

variable "web_app_name" {
  description = "The name of the web app"
  type        = string
  sensitive   = true
}

variable "repo_url" {
  type        = string
  description = "The repository URL"
  sensitive   = true
}

variable "gh_publish_profile_name" {
  type        = string
  description = "The secret name of Azure publish profile for deployment"
}

variable "gh_publish_profile_environment" {
  type        = string
  description = "The deployment environment name of `gh_publish_profile_name` secret"
}

variable "branch_name" {
  type        = string
  description = "The name of branch for deployment"
  default     = "main"
}
