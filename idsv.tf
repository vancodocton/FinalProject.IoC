resource "azurerm_postgresql_flexible_server_database" "identity" {
  name      = "identity-db"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}

resource "azurerm_linux_web_app" "identity" {
  name                = "FinalProjectIdentity"
  resource_group_name = data.azurerm_resource_group.rg_main.name
  location            = azurerm_service_plan.main_linux.location
  service_plan_id     = azurerm_service_plan.main_linux.id
  https_only          = true

  site_config {
    always_on = false // always_on cannot be set to true when using Development
    application_stack {
      dotnet_version = "6.0"
    }
    ftps_state = "FtpsOnly"
  }

  connection_string {
    name  = var.IDSV_IDENTITY_DB_CONNECTION_STRING_NAME
    type  = "SQLAzure"
    value = azurerm_key_vault_secret.postgres_identity_db_dotnet_connection_string.value
  }

  connection_string {
    name  = "demo"
    type  = "SQLAzure"
    value = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.postgres_identity_db_dotnet_connection_string.id})"
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      zip_deploy_file,
      client_certificate_exclusion_paths
    ]
  }
}

resource "azurerm_app_service_source_control" "idsv_github" {
  app_id   = azurerm_linux_web_app.identity.id
  repo_url = "https://github.com/vancodocton/FinalProject"
  branch   = "main"

  depends_on = [
    azurerm_linux_web_app.identity
  ]

  github_action_configuration {
    generate_workflow_file = false
  }

  lifecycle {
    ignore_changes = [
      github_action_configuration
    ]
  }
}
