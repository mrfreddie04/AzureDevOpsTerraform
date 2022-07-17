# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure TF to use AZ blob storage for terraform.tfstate file
terraform {
    backend "azurerm" {
        resource_group_name  = "tfstoragerg"
        storage_account_name = "tfstoragepersistence"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "East US"
}

resource "azurerm_container_group" "tfcg_test" {
  name                      = "weatherapi"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name

  ip_address_type     = "Public"
  dns_name_label      = "piotrfranekjanwa"
  os_type             = "Linux"

  container {
      name            = "weatherapi"
      image           = "piotrfranekjan/weatherapi:${var.imagebuild}"
      cpu             = "1"
      memory          = "1"

      ports {
          port        = 80
          protocol    = "TCP"
      }
  }
}