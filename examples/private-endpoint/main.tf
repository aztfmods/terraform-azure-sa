provider "azurerm" {
  features {}
}

module "region" {
  source = "github.com/aztfmods/module-azurerm-regions"

  workload    = var.workload
  environment = var.environment

  location = "westeurope"
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short
  location       = module.region.location
}

module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  vnet = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      plink = { cidr = ["10.18.1.0/24"], enforce_priv_link_endpoint = true }
    }
  }
  depends_on = [module.rg]
}

module "private_endpoint" {
  source = "github.com/aztfmods/module-azurerm-pep"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  endpoint = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    subnet_id    = module.network.subnets.plink.id
    resource_id  = module.storage.sa.id
    subresources = ["blob"]

    private_dns_zone = {
      name         = "privatelink.blob.core.windows.net"
      network_link = module.network.vnet.id
      a_record = {
        name = "storage"
        ttl  = 300
      }
    }
  }
  depends_on = [module.rg]
}

module "storage" {
  source = "../../"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  storage = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    enable = {
      public_network_access = false
    }
  }
  depends_on = [module.rg]
}
