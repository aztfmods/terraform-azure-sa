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

module "vnet" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8"]
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"], enforce_priv_link_endpoint = true }
      }
    }
  }
  depends_on = [module.global]
}

module "dns" {
  source = "github.com/aztfmods/module-azurerm-dns"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  dns = {
    private = {
      rg_name = module.global.groups.demo.name
      zones = {
        blob = {
          name = "privatelink.blob.core.windows.net"

          a_records = {
            contoso = { name = "contoso", ttl = 300, records = ["10.0.180.17"] }
          }

          link_to_vnet = {
            demo = {
              vnet    = module.vnet.vnets.demo.name
              rg_name = module.vnet.vnets.demo.resource_group_name
            }
          }
        }
      }
    }
  }
  depends_on = [module.global, module.vnet]
}

module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage_accounts = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name

      enable = {
        private_endpoint = true, subnet_id = module.vnet.subnets["demo.sn1"].id
      }
    }
  }
  depends_on = [module.global]
}