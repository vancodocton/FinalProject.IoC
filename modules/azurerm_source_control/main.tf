data "azurerm_linux_web_app" "main" {
  name = "${var.WEBAPP_NAME}-${var.INF_ENV}"
  resource_group_name = var.RESOURCE_GROUP_NAME
}

resource "azurerm_app_service_source_control" "main" {
  app_id   = data.azurerm_linux_web_app.main.id
  repo_url = var.REPO_URL
  branch   = var.BRANCH

  depends_on = [
    data.azurerm_linux_web_app.main
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
