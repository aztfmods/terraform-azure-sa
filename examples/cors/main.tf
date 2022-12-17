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

  storage_accounts = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name

      blob_service = {
        enable = { versioning = true, last_access_time = true, change_feed = true }

        cors_rules = {
          rule1 = {
            allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
            allowed_methods    = ["POST", "GET"]
            allowed_origins    = ["http://www.fabrikam.com"]
            exposed_headers    = ["x-ms-meta-*"]
            max_age_in_seconds = "200"
          }
          rule2 = {
            allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
            allowed_methods    = ["GET"]
            allowed_origins    = ["http://www.contoso.com"]
            exposed_headers    = ["x-ms-meta-*"]
            max_age_in_seconds = "200"
          }
        }

        policy = {
          delete_retention_in_days           = 8
          restore_in_days                    = 7
          container_delete_retention_in_days = 8
        }
      }
    }
  }
  depends_on = [module.global]
}