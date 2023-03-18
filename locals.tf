locals {
  containers = flatten([
    for sc_key, sc in try(var.storage.containers, {}) : {

      sc_key                = sc_key
      name                  = sc.name
      container_access_type = sc.access_type
      storage_account_name  = azurerm_storage_account.sa.name
    }
  ])
}

locals {
  shares = flatten([
    for fs_key, fs in try(var.storage.shares, {}) : {

      fs_key               = fs_key
      name                 = fs.name
      quota                = fs.quota
      storage_account_name = azurerm_storage_account.sa.name
    }
  ])
}

locals {
  queues = flatten([
    for sq_key, sq in try(var.storage.queues, {}) : {

      sq_key               = sq_key
      name                 = sq.name
      storage_account_name = azurerm_storage_account.sa.name
    }
  ])
}

locals {
  tables = flatten([
    for st_key, st in try(var.storage.tables, {}) : {

      st_key               = st_key
      name                 = st.name
      storage_account_name = azurerm_storage_account.sa.name
    }
  ])
}