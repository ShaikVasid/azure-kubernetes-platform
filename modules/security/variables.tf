variable "name" {
  description = "Base name used for security resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the security resources."
  type        = string
}

variable "location" {
  description = "Azure region where security resources are deployed."
  type        = string
}

variable "tags" {
  description = "Tags applied to security resources."
  type        = map(string)
  default     = {}
}
