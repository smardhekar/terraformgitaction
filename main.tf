provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "container-registry-rg"
  location = "East US 2"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "kspcontainerregistry"
  resource_group_name = azurerm_resource_group.default.name
  location            = "East US 2"
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "akscluster1" {
  name                = "akssamcluter143"
  location            = local.location
  resource_group_name = local.resource_group_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
