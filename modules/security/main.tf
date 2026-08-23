resource "azurerm_network_security_group" "aks" {
  name                = "${var.name}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
