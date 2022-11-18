terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    container_name       = "tfstate"
    storage_account_name = "finalprojecttfstate"
    key                  = "finalproject.prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
