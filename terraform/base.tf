terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.36"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

variable "apim-ref-rg" {
  type    = string
  default = "apim-ref-rg"
}

data "azurerm_resource_group" "apim-ref-rg" {
  name = var.apim-ref-rg
}