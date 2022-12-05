data "azurerm_linux_web_app" "main" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_source_control" "main" {
  app_id   = data.azurerm_linux_web_app.main.id
  repo_url = var.repo_url
  branch   = var.branch_name

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

locals {
  publish_profile_filename         = "publishing-profile.xml"
  script_publish_profile           = "az webapp deployment list-publishing-profiles --ids ${data.azurerm_linux_web_app.main.id} --xml"
  gh_secret_publish_profile_script = "gh secret --repo ${var.repo_url} set ${var.gh_publish_profile_name} --env ${var.gh_publish_profile_environment} --body $(${local.script_publish_profile})"
}
