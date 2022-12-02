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
    rg1 = {
      name     = "rg-${local.naming.company}-storage-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }

    rg2 = {
      name     = "rg-${local.naming.company}-storage-${local.naming.env}-${local.naming.region}"
      location = "southeastasia"
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
    demo1 = {
      location      = module.global.groups.rg1.location
      resourcegroup = module.global.groups.rg1.name

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }

    demo2 = {
      location      = module.global.groups.rg2.location
      resourcegroup = module.global.groups.rg2.name

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }
  }
  depends_on = [module.global]
}