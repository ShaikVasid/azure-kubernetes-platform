variable "location" {
  description = "Azure region where the AKS platform is deployed."
  type        = string
  default     = "canadacentral"
}

variable "resource_group_name" {
  description = "Resource group name for the AKS platform."
  type        = string
  default     = "rg-portfolio-aks-dev"
}

variable "vnet_address_space" {
  description = "CIDR address space for the AKS virtual network."
  type        = string
  default     = "10.30.0.0/16"
}

variable "aks_subnet_prefix" {
  description = "CIDR prefix for the AKS subnet."
  type        = string
  default     = "10.30.0.0/22"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = null
}

variable "system_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "user_vm_size" {
  description = "VM size for the AKS application node pool."
  type        = string
  default     = "Standard_D2s_v5"
}
