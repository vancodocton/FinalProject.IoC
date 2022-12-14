data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "random_pet" "suffix" {
  length = 1
  keepers = {
    workspace = terraform.workspace
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  # checkov:skip=CKV_AZURE_109: ADD REASON
  name                       = "FP-KeyVault-${random_pet.suffix.id}"
  location                   = data.azurerm_resource_group.main.location
  resource_group_name        = data.azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"
  purge_protection_enabled   = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    tf-workspace = terraform.workspace
  }
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "Recover",
    "Purge",
  ]
}

resource "azurerm_postgresql_flexible_server" "main" {
  #checkov:skip=CKV_AZURE_136: geo-redundant backups is not necessary for development purpose.
  resource_group_name = data.azurerm_resource_group.main.name

  name       = "psqlserver${random_pet.suffix.id}"
  location   = data.azurerm_resource_group.main.location
  sku_name   = "B_Standard_B1ms"
  version    = "14"
  storage_mb = 32768

  private_dns_zone_id = null
  delegated_subnet_id = null

  tags = {
    tf-workspace = terraform.workspace
  }

  administrator_login    = azurerm_key_vault_secret.postgres_server_admin_login.value
  administrator_password = azurerm_key_vault_secret.postgres_server_admin_password.value

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "main_allow_azure_services" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "main_allow_all" {
  name             = "AllowAllAccessFromPublic"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_service_plan" "main_linux" {
  name                = "ASP-Linux-${random_pet.suffix.id}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.azurerm_service_plan_sku_name

  tags = {
    tf-workspace = terraform.workspace
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  name = "workspace-${random_pet.suffix.id}"
  sku  = var.arm_log_analytics_workspace.sku

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  daily_quota_gb    = var.arm_log_analytics_workspace.daily_quota_gb
  retention_in_days = var.arm_log_analytics_workspace.retention_in_days

  tags = {
    tf-workspace = terraform.workspace
  }
}

resource "azurerm_application_insights" "main" {
  name                = "AAI-Web-${random_pet.suffix.id}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = {
    tf-workspace = terraform.workspace
  }
}
