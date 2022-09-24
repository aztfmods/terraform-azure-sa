provider "azurerm" {
  features {}
}

module "rgs" {
  source = "github.com/aztfmods/module-azurerm-rg"
  groups = {
    storage = { name = "rg-sa-weu", location = "westeurope" }
  }
}

module "storage" {
  source     = "../../"
  depends_on = [module.rgs]
  storage_accounts = {
    sa1 = {
      location          = module.rgs.groups.storage.location
      rgname            = module.rgs.groups.storage.name
      sku               = { tier = "Standard", type = "GRS" }
      enable_protection = true
      containers = {
        sc1 = { name = "mystore250", access_type = "private" }
        sc2 = { name = "mystore251", access_type = "private" }
      }
    }
  }
}