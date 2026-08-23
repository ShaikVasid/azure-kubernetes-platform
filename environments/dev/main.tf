terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "core"
}

locals {
  name = "portfolio-dev"
  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "azure-kubernetes-platform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

module "networking" {
  source              = "../../modules/networking"
  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = "10.30.0.0/16"
  aks_subnet_prefix   = "10.30.0.0/22"
  tags                = local.tags
}

module "aks" {
  source              = "../../modules/aks"
  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.networking.aks_subnet_id
  tags                = local.tags
}

output "resource_group_name" { value = azurerm_resource_group.this.name }
output "cluster_name" { value = module.aks.cluster_name }
output "cluster_id" { value = module.aks.cluster_id }
