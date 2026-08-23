variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) default = {} }

resource "azurerm_network_security_group" "aks" {
  name                = "${var.name}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

output "network_security_group_id" { value = azurerm_network_security_group.aks.id }
