module "storage" {
  source = "../../"
  storage_accounts = {
    sa1 = {
      location          = "westeurope"
      enable_protection = true
      sku               = { tier = "Standard", type = "GRS" }
      containers = {
        sc1 = { name = "mystore250", access_type = "private" }
        sc2 = { name = "mystore251", access_type = "private" }
      }
    }

    sa2 = {
      location          = "eastus2"
      enable_protection = true
      sku               = { tier = "Standard", type = "GRS" }
      shares = {
        fs1 = { name = "smbfileshare2", quota = 50 }
      }
    }
  }
}