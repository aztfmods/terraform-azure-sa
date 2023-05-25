provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo2 = { location = "westeurope" }
  }
}

module "network" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnet = {
    location      = module.global.groups.demo2.location
    resourcegroup = module.global.groups.demo2.name
    cidr          = ["10.18.0.0/16"]
    subnets = {
      plink = { cidr = ["10.18.1.0/24"], enforce_priv_link_endpoint = true }
    }
  }
  depends_on = [module.global]
}

module "private_link" {
  source = "github.com/aztfmods/module-azurerm-pep"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  endpoint = {
    location      = module.global.groups.demo2.location
    resourcegroup = module.global.groups.demo2.name

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
  depends_on = [module.global]
}

module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage = {
    location      = module.global.groups.demo2.location
    resourcegroup = module.global.groups.demo2.name

    enable = {
      sftp   = true
      is_hns = true
    }
  }
  depends_on = [module.global]
}

