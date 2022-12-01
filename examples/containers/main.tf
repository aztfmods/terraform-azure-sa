provider "azurerm" {
  features {}
}

locals {
  naming = {
    company = "cn"
    env     = "p"
    region  = "weu"
  }
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"
  rgs = {
    storage = {
      name     = "rg-${local.naming.company}-storage-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }
  }
}

module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    demo = {
      location      = module.global.groups.storage.location
      resourcegroup = module.global.groups.storage.name

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      containers = {
        sc1 = { name = "mystore250", access_type = "private" }
        sc2 = { name = "mystore251", access_type = "private" }
      }
    }
  }
  depends_on = [module.global]
}