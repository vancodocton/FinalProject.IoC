output "time_rotating_date" {
  value       = time_rotating.keyvault_secrets_rotation.rotation_rfc3339
  description = "The date that the secrets of the key vault should be renewed."
}

output "idsv" {
  value = {
    web_app_name        = azurerm_linux_web_app.identity.name,
    resource_group_name = azurerm_linux_web_app.identity.resource_group_name,
  }
  sensitive = true
}
