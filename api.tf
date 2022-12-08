resource "azurerm_postgresql_flexible_server_database" "api" {
  name      = "api-db"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}

resource "azurerm_linux_web_app" "api" {
  #checkov:skip=CKV_AZURE_13: API do not use built-in authentication
  #checkov:skip=CKV_AZURE_88: Will be fixed on prodution env
  name                = "FinalProjectApi-${random_pet.suffix.id}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = azurerm_service_plan.main_linux.location
  service_plan_id     = azurerm_service_plan.main_linux.id
  https_only          = true

  client_certificate_enabled = true
  client_certificate_mode    = "OptionalInteractiveUser"

  tags = {
    tf-workspace = terraform.workspace
  }
  logs {
    detailed_error_messages = true
    failed_request_tracing  = true
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 25
      }
    }
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.main.instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "disabled"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "disabled"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = "InstrumentationKey=${azurerm_application_insights.main.instrumentation_key};IngestionEndpoint=https://eastasia-0.in.applicationinsights.azure.com/;LiveEndpoint=https://eastasia.livediagnostics.monitor.azure.com/"
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DiagnosticServices_EXTENSION_VERSION            = "disabled"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }
  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING ",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }
  site_config {
    always_on = false // always_on cannot be set to true when using Development
    application_stack {
      dotnet_version = "6.0"
    }
    ftps_state    = "FtpsOnly"
    http2_enabled = true
  }
  identity {
    type = "SystemAssigned"
  }
  connection_string {
    name  = "PostgreSqlConnection"
    type  = "SQLAzure"
    value = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.postgres_api_db_dotnet_connection_string.id})"
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      zip_deploy_file,
      client_certificate_exclusion_paths
    ]
  }
}

resource "azurerm_key_vault_access_policy" "api_main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_linux_web_app.api.identity.0.tenant_id
  object_id    = azurerm_linux_web_app.api.identity.0.principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
}
