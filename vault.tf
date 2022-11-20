resource "random_password" "postgres_server_administrator" {
  length = 16
}

resource "azurerm_key_vault_secret" "postgres_server_admin_login" {
  # checkov:skip=CKV_AZURE_41: Will be fixed soon.
  name         = "postgre-server-administrator-login"
  value        = var.POSTGRES_SERVER_ADMINISTRATOR_LOGIN
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
  content_type = "text/plain"
  tags = {
  }
}

resource "azurerm_key_vault_secret" "postgres_server_admin_password" {
  # checkov:skip=CKV_AZURE_41: Will be fixed soon.
  name         = "postgre-server-administrator-password"
  value        = random_password.postgres_server_administrator.result
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
  content_type = "text/plain"
  tags = {
  }
}

resource "azurerm_key_vault_secret" "postgres_identity_db_dotnet_connection_string" {
  # checkov:skip=CKV_AZURE_41: Will be fixed soon.
  name         = "identity-db-dotnet-connection-string"
  value        = "Server=${azurerm_postgresql_flexible_server.main.name}.postgres.database.azure.com;Database=${azurerm_postgresql_flexible_server_database.identity.name};Port=5432;UID=${azurerm_key_vault_secret.postgres_server_admin_login.value};Password=${azurerm_key_vault_secret.postgres_server_admin_password.value};"
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
  content_type = "text/plain"
  tags = {
  }
}
