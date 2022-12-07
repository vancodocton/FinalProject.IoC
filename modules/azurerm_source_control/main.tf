data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_linux_web_app" "main" {
  name                = var.azure_app_service_name
  resource_group_name = data.azurerm_resource_group.main.name
}


data "github_repository" "main" {
  full_name = var.gh_repo_full_name
}

resource "azurerm_source_control_token" "github_main" {
  type  = "GitHub"
  token = var.github_token
}

resource "azurerm_app_service_source_control" "main" {
  app_id   = data.azurerm_linux_web_app.main.id
  repo_url = data.github_repository.main.html_url
  branch   = var.gh_repo_deployment_branch

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

resource "github_actions_environment_secret" "azure_app_service_name" {
  environment     = var.gh_environment_name
  repository      = data.github_repository.main.name
  secret_name     = var.gh_azure_app_service_secret_name
  plaintext_value = data.azurerm_linux_web_app.main.name
}

data "local_sensitive_file" "input" {
  filename = "profile.xml"
  depends_on = [
    null_resource.get_publishing_profile
  ]
}

resource "null_resource" "get_publishing_profile" {
  provisioner "local-exec" {
    command = "az webapp deployment list-publishing-profiles --ids ${data.azurerm_linux_web_app.main.id} --xml > profile.xml"
  }
}

resource "github_actions_environment_secret" "azure_publish_profile" {
  environment     = var.gh_environment_name
  repository      = data.github_repository.main.name
  secret_name     = var.gh_azure_publish_profile_secret_name
  plaintext_value = data.local_sensitive_file.input.content
}
