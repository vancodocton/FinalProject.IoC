output "time_rotating_date" {
  value       = time_rotating.keyvault_secrets_rotation.rotation_rfc3339
  description = "The date that the secrets of the key vault should be renewed."
}
