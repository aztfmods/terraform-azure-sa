provider "azurerm" {
  features {}
}

#----------------------------------------------------------------------------------------
# Resourcegroups
#----------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = "rg-storage-${var.env}-001"
  location = "westeurope"
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

  name                            = "sa${var.env}${each.key}${random_string.random[each.key].result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = each.value.location
  account_tier                    = each.value.sku.tier
  account_replication_type        = each.value.sku.type
  account_kind                    = "StorageV2"
  allow_nested_items_to_be_public = false

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
# advanced threat protection
#----------------------------------------------------------------------------------------

resource "azurerm_advanced_threat_protection" "prot" {
  for_each = {
    for sa, defender in var.storage_accounts : sa => defender
    if defender.enable_protection == true
  }

  target_resource_id = azurerm_storage_account.sa[each.key].id
  enabled            = each.value.enable_protection
}