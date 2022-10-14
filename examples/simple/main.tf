provider "azurerm" {
  features {}
}

locals {
  naming = {
    company = "cn"
    env     = "p"
    region  = "weu"
  }
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"
  rgs = {
    storage = {
      name     = "rg-${local.naming.company}-storage-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }
  }
}

module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    demo = {
      location      = module.global.groups.storage.location
      resourcegroup = module.global.groups.storage.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      mgt_policies = {
        rules = {
          rule_1 = {
            name    = "rule1"
            enabled = true
            filters = {
              filter_specs = {
                prefix_match = ["container1/prefix1"]
                blob_types   = ["blockBlob"]
              }
            }
            actions = {
              base_blob = {
                blob_specs = {
                  tier_to_cool_after_days_since_modification_greater_than    = 11
                  tier_to_archive_after_days_since_modification_greater_than = 51
                  delete_after_days_since_modification_greater_than          = 101
                }
              }
              snapshot = {
                snapshot_specs = {
                  change_tier_to_archive_after_days_since_creation = 90
                  change_tier_to_cool_after_days_since_creation    = 23
                  delete_after_days_since_creation_greater_than    = 31
                }
              }
              version = {
                version_specs = {
                  change_tier_to_archive_after_days_since_creation = 9
                  change_tier_to_cool_after_days_since_creation    = 90
                  delete_after_days_since_creation                 = 3
                }
              }
            }
          },
          rule_2 = {
            name    = "rule2"
            enabled = true
            filters = {
              filter_specs = {
                prefix_match = ["container1/prefix3"]
                blob_types   = ["blockBlob"]
              }
            }
            actions = {
              base_blob = {
                blob_specs = {
                  tier_to_cool_after_days_since_last_access_time_greater_than    = 30
                  tier_to_archive_after_days_since_last_access_time_greater_than = 90
                  delete_after_days_since_last_access_time_greater_than          = 365
                }
              }
            }
          }
        }
      }
    }
  }
  depends_on = [module.global]
}