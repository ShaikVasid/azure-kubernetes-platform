variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "kubernetes_version" { type = string default = null }
variable "system_vm_size" { type = string default = "Standard_D2s_v5" }
variable "user_vm_size" { type = string default = "Standard_D2s_v5" }
variable "tags" { type = map(string) default = {} }

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-aks"
  kubernetes_version  = var.kubernetes_version

  identity { type = "SystemAssigned" }

  azure_active_directory_role_based_access_control_enabled = true
  role_based_access_control_enabled                        = true

  default_node_pool {
    name           = "system"
    vm_size        = var.system_vm_size
    vnet_subnet_id = var.subnet_id
    node_count     = 2
    type           = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin    = "azure"
    network_plugin_mode = "overlay"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_vm_size
  vnet_subnet_id        = var.subnet_id
  node_count            = 2
  mode                  = "User"
  node_labels = {
    "workload-type" = "application"
  }
  tags = var.tags
}

output "cluster_id" { value = azurerm_kubernetes_cluster.this.id }
output "cluster_name" { value = azurerm_kubernetes_cluster.this.name }
output "kubelet_identity_object_id" { value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id }
