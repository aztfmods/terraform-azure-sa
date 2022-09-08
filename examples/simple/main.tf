module "storage" {
  source = "../../"
  storage_accounts = {
    sa1 = {
      location = "westeurope"
      sku      = { tier = "Standard", type = "GRS" }
    }

    sa2 = {
      location = "eastus2"
      sku      = { tier = "Standard", type = "GRS" }
    }
  }
}