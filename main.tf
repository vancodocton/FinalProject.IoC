data "azurerm_resource_group" "rg_main" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = "FinalProjectKeyVault"
  location                   = data.azurerm_resource_group.rg_main.location
  resource_group_name        = data.azurerm_resource_group.rg_main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_postgresql_flexible_server" "main" {
  resource_group_name = data.azurerm_resource_group.rg_main.name

  name       = var.POSTGRES_SERVER_NAME
  location   = data.azurerm_resource_group.rg_main.location
  sku_name   = "B_Standard_B1ms"
  version    = "14"
  storage_mb = 32768

  private_dns_zone_id = null
  delegated_subnet_id = null

  tags = {}

  administrator_login    = azurerm_key_vault_secret.postgres_server_admin_login.value
  administrator_password = azurerm_key_vault_secret.postgres_server_admin_password.value

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgreSQL_allow_access_to_azure_service" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgreSQL_allow_access_to_all" {
  name             = "AllowAllAccessFromPublic"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
