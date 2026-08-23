variable "name" {
  description = "Base name used for networking resources."
  type        = string
}

variable "location" {
  description = "Azure region where networking resources are deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the networking resources."
  type        = string
}

variable "address_space" {
  description = "Address space for the Azure virtual network."
  type        = string
}

variable "aks_subnet_prefix" {
  description = "CIDR prefix for the AKS subnet."
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
  default     = {}
}
