azurerm_service_plan_sku_name = "B1"

arm_log_analytics_workspace = {
  sku               = "PerGB2018"
  daily_quota_gb    = 0.5
  retention_in_days = 30
}
