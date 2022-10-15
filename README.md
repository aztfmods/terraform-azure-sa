![example workflow](https://github.com/aztfmods/module-azurerm-sa/actions/workflows/validate.yml/badge.svg)

# Storage Account

Terraform module which creates storage account resources on Azure.

The below features and integrations are made available:

- multiple storage accounts
- multiple [shares](#usage-multiple-storage-accounts-multiple-fileshares), [tables](#usage-multiple-storage-accounts-multiple-tables), [containers](#usage-single-storage-account-multiple-containers) and [queues](#usage-single-storage-account-multiple-queues) on each storage account
- advanced threat protection
- [management policies](#usage-management-policy-using-multiple-rules) using multiple rules
- [terratest](https://terratest.gruntwork.io) is used to validate different integrations
- [diagnostic](examples/diagnostic-settings/main.tf) logs integration

The below examples shows the usage when consuming the module:

## Usage: single storage account multiple containers

```hcl
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

      containers = {
        sc1 = { name = "mystore250", access_type = "private" }
        sc2 = { name = "mystore251", access_type = "private" }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: multiple storage accounts multiple tables

```hcl
module "storage" {
  source = "../.."

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    sa1 = {
      location      = module.rgs.groups.storageeus2.location
      resourcegroup = module.rgs.groups.storageeus2.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      tables = {
        t1 = {name = "table1"}
        t2 = {name = "table2"}
      }

    sa2 = {
      location      = module.rgs.groups.storagesea.location
      resourcegroup = module.rgs.groups.storagesea.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      tables = {
        t1 = {name = "table1"}
        t2 = {name = "table2"}
      }
    }
  }
}
```

## Usage: single storage account multiple queues

```hcl
module "storage" {
  source = "../.."

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    sa1 = {
      location      = module.rgs.groups.storage.location
      resourcegroup = module.rgs.groups.storage.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      queues = {
        q1 = {name = "queue1"}
        q2 = {name = "queue2"}
      }
    }
  }
}
```

## Usage: multiple storage accounts multiple fileshares

```hcl
module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    sa1 = {
      location      = module.rgs.groups.storageeus.location
      resourcegroup = module.rgs.groups.storageeus.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      shares = {
        fs1 = {name = "smbfileshare1",quota = 50}
        fs2 = {name = "smbfileshare2",quota = 10}
      }

    sa2 = {
      location      = module.rgs.groups.storagesea.location
      resourcegroup = module.rgs.groups.storageesea.name
      enable        = { protection = true, mgtpolicy = true }

      sku = {
        tier = "Standard"
        type = "GRS"
      }

      shares = {
        fs1 = {name = "smbfileshare1",quota = 5}
        fs2 = {name = "smbfileshare2",quota = 10}
      }
    }
  }
}
```

## Usage: management policy using multiple rules

```hcl
module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage_accounts = {
    sa1 = {
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
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [azurerm_storage_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_advanced_threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `storage_accounts` | describes storage related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `sa` | contains all storage accounts |
| `merged_ids` | contains all resource id's specified within the object |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-sa/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-vnet/blob/main/LICENSE) for full details.