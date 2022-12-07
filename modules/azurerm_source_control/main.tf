data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_linux_web_app" "main" {
  name                = var.web_app_name
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_source_control_token" "github_main" {
  type  = "GitHub"
  token = var.github_token
}

resource "azurerm_app_service_source_control" "main" {
  app_id   = data.azurerm_linux_web_app.main.id
  repo_url = var.repo_url
  branch   = var.branch_name

  depends_on = [
    azurerm_source_control_token.github_main
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

locals {
  script_publish_profile           = "az webapp deployment list-publishing-profiles --ids ${data.azurerm_linux_web_app.main.id} --xml"
  script_gh_secret_publish_profile = "gh secret --repo ${var.repo_url} set ${var.gh_publish_profile_name} --env ${var.gh_publish_profile_environment} --body $(${local.script_publish_profile})"
  script_gh_secret_app_name        = "gh secret --repo ${var.repo_url} set ${var.gh_azure_app_name_name} --env ${var.gh_publish_profile_environment} --body '${data.azurerm_linux_web_app.main.name}'"

}
