![example workflow](https://github.com/dkooll/terraform-azurerm-storageaccount/actions/workflows/validate.yml/badge.svg)

# Storage Account

Terraform module which creates storage account resources on Azure.

The below features are made available:

- Multiple storage accounts
- Multiple shares, tables, containers and queues on each storage account
- Advanced threat protection
- Terratest is used to validate different integrations in [examples](examples)

The below examples shows the usage when consuming the module:

## Usage: single storage account multiple containers

```hcl
module "storage" {
  source = "github.com/dkooll/terraform-azurerm-storageaccount"
  version = "1.0.0"
  storage_accounts = {
    sa1 = {
      location          = "westeurope"
      enable_protection = "true"
      sku               = { tier = "Standard", type = "GRS" }
      containers = {
        sc1 = {name = "mystore250",access_type = "private"}
        sc2 = {name = "mystore251",access_type = "private"}
      }
    }
  }
}
```

## Usage: multiple storage accounts multiple tables

```hcl
module "storage" {
  source = "github.com/dkooll/terraform-azurerm-storageaccount"
  version = "1.0.0"
  storage_accounts = {
    sa1 = {
      location          = "eastus2"
      enable_protection = "true"
      sku               = { tier = "Standard", type = "GRS" }
      tables = {
        t1 = {name = "table1"}
        t2 = {name = "table2"}
      }

    sa2 = {
      location          = "southeastasia"
      tier              = "Standard"
      type              = "GRS"
      kind              = "StorageV2"
      enable_protection = "false"
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
  source = "github.com/dkooll/terraform-azurerm-storageaccount"
  version = "1.0.0"
  storage_accounts = {
    sa1 = {
      location          = "eastus2"
      enable_protection = "false"
      sku               = { tier = "Standard", type = "GRS" }
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
  source = "github.com/dkooll/terraform-azurerm-storageaccount"
  version = "1.0.0"
  storage_accounts = {
    sa1 = {
      location          = "eastus2"
      enable_protection = "false"
      sku               = { tier = "Standard", type = "GRS" }
      shares = {
        fs1 = {name = "smbfileshare1",quota = 50}
        fs2 = {name = "smbfileshare2",quota = 10}
      }

    sa2 = {
      location          = "southeastasia"
      enable_protection = "false"
      sku               = { tier = "Standard", type = "GRS" }
      shares = {
        fs1 = {name = "smbfileshare1",quota = 5}
        fs2 = {name = "smbfileshare2",quota = 10}
      }
    }
  }
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
| [azurerm_advanced_threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `storage_accounts` | describes storage related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `storageaccounts` | contains all storage accounts |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/dkooll/terraform-azurerm-vnet/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/dkooll/terraform-azurerm-vnet/tree/master/LICENSE) for full details.