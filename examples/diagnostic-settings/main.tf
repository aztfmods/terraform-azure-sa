provider "azurerm" {
  features {}
}

module "logging" {
  source = "github.com/aztfmods/module-azurerm-law"
  laws = {
    diags = {
      location      = "westeurope"
      resourcegroup = "rg-law-weeu"
      sku           = "PerGB2018"
      retention     = 30
    }
  }
}

module "storage" {
  source = "../../"
  storage_accounts = {
    sa1 = {
      location          = "westeurope"
      resourcegroup     = "rg-storage-weeu"
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