terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_linux_web_app" "identity" {
  name = "FinalProjectIdentity"
  resource_group_name = "FinalProject"
}

resource "azurerm_app_service_source_control" "idsv_github" {
  app_id   = data.azurerm_linux_web_app.identity.id
  repo_url = "https://github.com/vancodocton/FinalProject"
  branch   = "main"

  depends_on = [
    data.azurerm_linux_web_app.identity
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
