module "storage" {
  source = "../../"
  storage_accounts = {
    sa1 = {
      location          = "westeurope"
      resourcegroup     = "rg-storage-weeu"
      sku               = { tier = "Standard", type = "GRS" }
      enable_protection = true
      containers = {
        sc1 = { name = "mystore250", access_type = "private" }
        sc2 = { name = "mystore251", access_type = "private" }
      }
    }

    sa2 = {
      location          = "eastus2"
      resourcegroup     = "rg-storage-eus2"
      sku               = { tier = "Standard", type = "GRS" }
      enable_protection = true
      shares = {
        fs1 = { name = "smbfileshare2", quota = 50 }
      }
    }
  }
}