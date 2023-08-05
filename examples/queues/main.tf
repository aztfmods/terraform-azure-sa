provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg?ref=v0.1.0"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "storage" {
  source = "github.com/aztfmods/terraform-azure-sa?ref=v1.17.1"

  workload    = var.workload
  environment = var.environment

  storage = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
