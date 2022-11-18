resource "random_password" "postgres_server_administrator" {
  length = 16
}

resource "azurerm_key_vault_secret" "postgres_server_admin_login" {
  name         = "postgre-server-administrator-login"
  value        = var.POSTGRES_SERVER_ADMINISTRATOR_LOGIN
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "postgres_server_admin_password" {
  name         = "postgre-server-administrator-password"
  value        = random_password.postgres_server_administrator.result
  key_vault_id = azurerm_key_vault.main.id
}
