# Storage Account

This terraform module simplifies the process of creating and managing storage accounts on azure with customizable options and features, offering a flexible and powerful solution for managing azure storage through code.

The below features and integrations are made available:

- shares, tables, containers, queues support
- management policies using multiple rules
- terratest is used to validate different integrations
- cors rules support
- advanced threat protection

The below examples shows the usage when consuming the module:

## Usage: containers

```hcl
module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

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
```

## Usage: tables

```hcl
module "storage" {
  source = "../.."

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage = {
    location      = module.rgs.groups.storageeus2.location
    resourcegroup = module.rgs.groups.storageeus2.name

    tables = {
      t1 = {name = "table1"}
      t2 = {name = "table2"}
    }
  }
}
```

## Usage: queues

```hcl
module "storage" {
  source = "../.."

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage = {
    location      = module.rgs.groups.storage.location
    resourcegroup = module.rgs.groups.storage.name

    queues = {
      q1 = {name = "queue1"}
      q2 = {name = "queue2"}
    }
  }
}
```

## Usage: fileshares

```hcl
module "storage" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  storage = {
    location      = module.rgs.groups.storageeus.location
    resourcegroup = module.rgs.groups.storageeus.name

    shares = {
      fs1 = {name = "smbfileshare1",quota = 50}
      fs2 = {name = "smbfileshare2",quota = 10}
    }
  }
}
```

## Usage: management policy

```hcl
module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

    enable = {
      management_policy = true
      threat_protection = true
    }

    blob_properties = {
      enable = {
        last_access_time = true
      }
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
                auto_tier_to_hot_from_cool_enabled                             = true
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

## Usage: blob cors rules

```hcl
module "storage" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  storage = {
    location      = module.global.groups.demo.location
    resourcegroup = module.global.groups.demo.name

    blob_properties = {
      enable = {
        versioning       = true
        last_access_time = true
        change_feed      = true
        restore_policy   = true
      }

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
| `storage` | describes storage related configuration | object | yes |
| `company` | contains the company name used, for naming convention	| string | yes |
| `region` | contains the shortname of the region, used for naming convention	| string | yes |
| `env` | contains shortname of the environment used for naming convention	| string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `sa` | contains all storage accounts |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-sa/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-vnet/blob/main/LICENSE) for full details.

## References

- [Storage Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/storage)
- [Storage Accounts Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/storagerp/storage-accounts)