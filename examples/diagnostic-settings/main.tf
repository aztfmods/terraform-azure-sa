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

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  laws = {
    diags = {
      location      = module.global.groups.storage.location
      resourcegroup = module.global.groups.storage.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
  depends_on = [module.global]
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
      location      = module.rgs.groups.storage.location
      resourcegroup = module.rgs.groups.storage.name

      enable = {
        storage_management_policy  = true
        advanced_threat_protection = true
      }

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }
  }
  depends_on = [module.rgs]
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags"
  count  = length(module.storage.merged_ids)

  resource_id           = element(module.storage.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}