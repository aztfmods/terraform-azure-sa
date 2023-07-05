provider "azurerm" {
  features {}
}

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law?ref=v0.1.0"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  laws = {
    diags = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
  depends_on = [module.global]
}

module "storage" {
  source = "github.com/aztfmods/module-azurerm-storage?ref=v0.1.0"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage_accounts = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name

      enable = {
        advanced_threat_protection = true
      }

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }
  }
  depends_on = [module.global]
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags?ref=v0.1.0"
  count  = length(module.storage.merged_ids)

  resource_id           = element(module.storage.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}
