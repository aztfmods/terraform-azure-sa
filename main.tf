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