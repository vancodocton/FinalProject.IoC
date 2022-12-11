azurerm_service_plan_sku_name = "S1"

arm_log_analytics_workspace = {
  sku               = "PerGB2018"
  daily_quota_gb    = -1
  retention_in_days = 30
}
