#----------------------------------------------------------------------------------------
# Resourcegroups
#----------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  for_each = var.storage_accounts

  name = each.value.resourcegroup
}

#----------------------------------------------------------------------------------------
# Generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  for_each = var.storage_accounts

  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# Storage accounts
#----------------------------------------------------------------------------------------

resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                            = "sa${var.naming.company}${each.key}${var.naming.env}${var.naming.region}${random_string.random[each.key].result}"
  resource_group_name             = data.azurerm_resource_group.rg[each.key].name
  location                        = data.azurerm_resource_group.rg[each.key].location
  account_tier                    = each.value.sku.tier
  account_replication_type        = each.value.sku.type
  account_kind                    = "StorageV2"
  allow_nested_items_to_be_public = false

  blob_properties {
    last_access_time_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }
}

#----------------------------------------------------------------------------------------
# Containers
#----------------------------------------------------------------------------------------

resource "azurerm_storage_container" "sc" {
  for_each = {
    for sc in local.containers : "${sc.sa_key}.${sc.sc_key}" => sc
  }

  name                  = each.value.name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
}

#----------------------------------------------------------------------------------------
# Queues
#----------------------------------------------------------------------------------------

resource "azurerm_storage_queue" "sq" {
  for_each = {
    for sq in local.queues : "${sq.sa_key}.${sq.sq_key}" => sq
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
}

#----------------------------------------------------------------------------------------
# shares
#----------------------------------------------------------------------------------------

resource "azurerm_storage_share" "sh" {
  for_each = {
    for fs in local.shares : "${fs.sa_key}.${fs.fs_key}" => fs
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
  quota                = each.value.quota
}

#----------------------------------------------------------------------------------------
# tables
#----------------------------------------------------------------------------------------

resource "azurerm_storage_table" "st" {
  for_each = {
    for st in local.tables : "${st.sa_key}.${st.st_key}" => st
  }

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
}

#----------------------------------------------------------------------------------------
# management policies
#----------------------------------------------------------------------------------------

resource "azurerm_storage_management_policy" "mgmt_policy" {
  for_each = {
    for sa, mgt_policy in var.storage_accounts : sa => mgt_policy
    if mgt_policy.enable.mgtpolicy == true
  }

  storage_account_id = azurerm_storage_account.sa[each.key].id

  dynamic "rule" {
    for_each = try(each.value.mgt_policies.rules, {})

    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      dynamic "filters" {
        for_each = try(rule.value.filters, {})

        content {
          prefix_match = try(filters.value.prefix_match, null)
          blob_types   = try(filters.value.blob_types, null)

          dynamic "match_blob_index_tag" {
            for_each = try(filters.match_blob_index_tag, {})

            content {
              name      = try(match_blob_index_tag.value.name, null)
              operation = try(match_blob_index_tag.value.operation, null)
              value     = try(match_blob_index_tag.value.value, null)
            }
          }
        }

      }
      actions {
        dynamic "base_blob" {
          for_each = try(rule.value.actions.base_blob, {})

          content {
            tier_to_cool_after_days_since_modification_greater_than        = try(base_blob.value.tier_to_cool_after_days_since_modification_greater_than, null)
            tier_to_cool_after_days_since_last_access_time_greater_than    = try(base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than, null)
            tier_to_archive_after_days_since_modification_greater_than     = try(base_blob.value.tier_to_archive_after_days_since_modification_greater_than, null)
            tier_to_archive_after_days_since_last_access_time_greater_than = try(base_blob.value.tier_to_archive_after_days_since_last_access_time_greater_than, null)
            delete_after_days_since_modification_greater_than              = try(base_blob.value.delete_after_days_since_modification_greater_than, null)
            delete_after_days_since_last_access_time_greater_than          = try(base_blob.value.delete_after_days_since_last_access_time_greater_than, null)
          }
        }

        dynamic "snapshot" {
          for_each = try(rule.value.actions.snapshot, {})

          content {
            change_tier_to_archive_after_days_since_creation = try(snapshot.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation    = try(snapshot.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation_greater_than    = try(snapshot.value.delete_after_days_since_creation_greater_than, null)
          }
        }

        dynamic "version" {
          for_each = try(rule.value.actions.version, {})

          content {
            change_tier_to_archive_after_days_since_creation = try(version.value.change_tier_to_archive_after_days_since_creation, null)
            change_tier_to_cool_after_days_since_creation    = try(version.value.change_tier_to_cool_after_days_since_creation, null)
            delete_after_days_since_creation                 = try(version.value.delete_after_days_since_creation, null)
          }
        }
      }
    }
  }
}

#----------------------------------------------------------------------------------------
# advanced threat protection
#----------------------------------------------------------------------------------------

resource "azurerm_advanced_threat_protection" "prot" {
  for_each = {
    for sa, defender in var.storage_accounts : sa => defender
    if defender.enable.protection == true
  }

  target_resource_id = azurerm_storage_account.sa[each.key].id
  enabled            = each.value.enable.protection
}