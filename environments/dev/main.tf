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
  source = "../../modules/networking"

  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  tags                = local.tags
}

module "security" {
  source = "../../modules/security"

  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

module "aks" {
  source = "../../modules/aks"

  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.networking.aks_subnet_id
  kubernetes_version  = var.kubernetes_version
  system_vm_size      = var.system_vm_size
  user_vm_size        = var.user_vm_size
  tags                = local.tags
}

output "resource_group_name" {
  description = "Name of the AKS resource group."
  value       = azurerm_resource_group.this.name
}

output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = module.aks.cluster_name
}

output "cluster_id" {
  description = "Resource ID of the AKS cluster."
  value       = module.aks.cluster_id
}
