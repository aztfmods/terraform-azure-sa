provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo  = { location = "westeurope" }
    demo2 = { location = "southeastasia" }
  }
}

module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage_accounts = {
    demo1 = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }

    demo2 = {
      location      = module.global.groups.demo2.location
      resourcegroup = module.global.groups.demo2.name

      sku = {
        tier = "Standard"
        type = "GRS"
      }
    }
  }
  depends_on = [module.global]
}