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

      queue_properties = {
        logging = {
          version               = "1.0"
          delete                = true
          read                  = true
          write                 = true
          retention_policy_days = 8
        }

        cors_rules = {
          rule1 = {
            allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
            allowed_methods    = ["POST", "GET"]
            allowed_origins    = ["http://www.fabrikam.com"]
            exposed_headers    = ["x-ms-meta-*"]
            max_age_in_seconds = "200"
          }
        }

        hour_metrics = {
          version               = "1.0"
          enabled               = true
          include_apis          = true
          retention_policy_days = 8
        }
      }

      queues = {
        q1 = { name = "queue1" }
        q2 = { name = "queue2" }
      }
    }
  }
  depends_on = [module.global]
}