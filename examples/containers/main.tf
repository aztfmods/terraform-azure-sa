provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo = { location = "westeurope" }
  }
}

module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

    containers = {
      sc1 = { name = "mystore250", access_type = "private" }
      sc2 = { name = "mystore251", access_type = "private" }
    }
  }
  depends_on = [module.global]
}