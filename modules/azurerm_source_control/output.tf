output "uses_github_action" {
  value = azurerm_app_service_source_control.main.uses_github_action
}

output "gh_secret_publish_profile_name" {
  value = var.gh_publish_profile_name
}

output "gh_secret_app_name_name" {
  value = var.gh_azure_app_name_name
}

output "script_gh_secret_publish_profile" {
  value     = local.script_gh_secret_publish_profile
  sensitive = true
}

output "script_gh_secret_app_name" {
  value     = local.script_gh_secret_app_name
  sensitive = true
}
