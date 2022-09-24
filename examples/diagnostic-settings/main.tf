provider "azurerm" {
  features {}
}

module "rgs" {
  source = "github.com/aztfmods/module-azurerm-rg"
  groups = {
    storage = { name = "rg-sa-weu", location = "westeurope" }
  }
}

module "logging" {
  source     = "github.com/aztfmods/module-azurerm-law?ref=main"
  depends_on = [module.rgs]
  laws = {
    diags = {
      location      = module.rgs.groups.storage.location
      resourcegroup = module.rgs.groups.storage.name
      sku           = "PerGB2018"
      retention     = 30
    }
  }
}

module "storage" {
  source     = "../../"
  depends_on = [module.rgs]
  storage_accounts = {
    sa1 = {
      location          = module.rgs.groups.storage.location
      resourcegroup     = module.rgs.groups.storage.name
      sku               = { tier = "Standard", type = "GRS" }
      enable_protection = true
    }
  }
}

module "diagnostic_settings" {
  source = "github.com/aztfmods/module-azurerm-diags"
  count  = length(module.storage.merged_ids)

  resource_id           = element(module.storage.merged_ids, count.index)
  logs_destinations_ids = [lookup(module.logging.laws.diags, "id", null)]
}