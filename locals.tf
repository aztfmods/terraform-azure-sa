locals {
  containers = flatten([
    for sa_key, sa in var.storage_accounts : [
      for sc_key, sc in try(sa.containers, {}) : {

        sa_key                = sa_key
        sc_key                = sc_key
        name                  = sc.name
        container_access_type = sc.access_type
        storage_account_name  = azurerm_storage_account.sa[sa_key].name
      }
    ]
  ])
}

locals {
  shares = flatten([
    for sa_key, sa in var.storage_accounts : [
      for fs_key, fs in try(sa.shares, {}) : {

        sa_key               = sa_key
        fs_key               = fs_key
        name                 = fs.name
        quota                = fs.quota
        storage_account_name = azurerm_storage_account.sa[sa_key].name
      }
    ]
  ])
}

locals {
  queues = flatten([
    for sa_key, sa in var.storage_accounts : [
      for sq_key, sq in try(sa.queues, {}) : {

        sa_key               = sa_key
        sq_key               = sq_key
        name                 = sq.name
        storage_account_name = azurerm_storage_account.sa[sa_key].name
      }
    ]
  ])
}

locals {
  tables = flatten([
    for sa_key, sa in var.storage_accounts : [
      for st_key, st in try(sa.tables, {}) : {

        sa_key               = sa_key
        st_key               = st_key
        name                 = st.name
        storage_account_name = azurerm_storage_account.sa[sa_key].name
      }
    ]
  ])
}