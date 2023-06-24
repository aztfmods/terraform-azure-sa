provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "storage" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  storage = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    share_properties = {
      smb = {
        versions                    = ["SMB3.1.1"]
        authentication_types        = ["Kerberos"]
        channel_encryption_type     = ["AES-256-GCM"]
        kerb_ticket_encryption_type = ["AES-256"]
        multichannel_enabled        = false
      }

      cors_rules = {
        rule1 = {
          allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
          allowed_methods    = ["POST", "GET"]
          allowed_origins    = ["http://www.fabrikam.com"]
          exposed_headers    = ["x-ms-meta-*"]
          max_age_in_seconds = "200"
        }
      }

      policy = {
        retention_in_days = 8
      }
    }

    shares = {
      fs1 = { name = "share1", quota = 50 }
      fs2 = { name = "share2", quota = 10 }
    }
  }
  depends_on = [module.rg]
}

