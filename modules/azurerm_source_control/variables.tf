
variable "RESOURCE_GROUP_NAME" {
  description = "The name of the resource group."
  type        = string
  sensitive   = true
}

variable "WEBAPP_NAME" {
  description = "The name of the web app"
  type        = string
  sensitive   = true
}

variable "REPO_URL" {
  type        = string
  description = "The repository URL"
  sensitive   = true
}

variable "BRANCH" {
  type        = string
  description = "The name of branch for deployment"
  default     = "main"
}

variable "INF_ENV" {
  description = "The environment name of infrastructure stack."
  type        = string
  default     = "Dev"
}
