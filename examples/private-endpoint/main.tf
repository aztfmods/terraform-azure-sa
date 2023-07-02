provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "network" {
  source = "github.com/aztfmods/terraform-azure-vnet"

  workload    = var.workload
  environment = var.environment

  vnet = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      plink = {
        cidr = ["10.18.1.0/24"]

        enforce_priv_link_endpoint = true
      }
    }
  }
  depends_on = [module.rg]
}

module "private_endpoint" {
  source = "github.com/aztfmods/terraform-azure-pep"

  workload    = var.workload
  environment = var.environment

  endpoint = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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

  workload    = var.workload
  environment = var.environment

  storage = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    enable = {
      public_network_access = false
    }
  }
  depends_on = [module.rg]
}
