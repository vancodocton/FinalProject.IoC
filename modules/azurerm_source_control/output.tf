output "uses_github_action" {
  value = azurerm_app_service_source_control.main.uses_github_action
}

output "script_gh_secret_publish_profile" {
  value     = local.gh_secret_publish_profile_script
  sensitive = true
}
