output "uses_github_action" {
  value = azurerm_app_service_source_control.main.uses_github_action
}

output "publishing_profile" {
  value     = data.local_sensitive_file.input.content
  sensitive = true
}