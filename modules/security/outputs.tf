output "network_security_group_id" {
  description = "Resource ID of the AKS network security group."
  value       = azurerm_network_security_group.aks.id
}
