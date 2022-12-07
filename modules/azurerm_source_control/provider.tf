terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }

  backend "azurerm" {
    container_name       = "tfstate"
    storage_account_name = "finalprojecttfstate"
    key                  = "COMP1682.arm_source_control.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "github" {
  token = var.github_token
}
