terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.29.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
 resource_group_name= "aks_RG"
 location = "eastus"
}

resource "azurerm_resource_group" "rgname" {
    name = local.resource_group_name
    location = local.location  
}

resource "azurerm_container_registry" "acr1" {
  name                = "containerRegistry0909"
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "akscluster1" {
  name                = "akscluter123"
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