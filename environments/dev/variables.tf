variable "location" {
  description = "Azure region"
  type        = string
  default     = "canadacentral"
}

variable "resource_group_name" {
  description = "Resource group for the AKS platform"
  type        = string
  default     = "rg-portfolio-aks-dev"
}
