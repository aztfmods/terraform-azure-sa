provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg?ref=v0.1.0"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "storage" {
  source = "github.com/aztfmods/terraform-azure-sa?ref=v1.17.1"

  workload    = var.workload
  environment = var.environment

  storage = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    enable = {
      management_policy = true
      threat_protection = true
    }

    blob_properties = {
      enable = {
        versioning       = true
        last_access_time = true
        change_feed      = true
        restore_policy   = true
      }

      cors_rules = {
        rule1 = {
          allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
          allowed_methods    = ["POST", "GET"]
          allowed_origins    = ["http://www.fabrikam.com"]
          exposed_headers    = ["x-ms-meta-*"]
          max_age_in_seconds = "200"
        }
        rule2 = {
          allowed_headers    = ["x-ms-meta-data*", "x-ms-meta-target*"]
          allowed_methods    = ["GET"]
          allowed_origins    = ["http://www.contoso.com"]
          exposed_headers    = ["x-ms-meta-*"]
          max_age_in_seconds = "200"
        }
      }

      policy = {
        delete_retention_in_days           = 8
        restore_in_days                    = 7
        container_delete_retention_in_days = 8
      }
    }

    queue_properties = {
      logging = {
        version               = "1.0"
        delete                = true
        read                  = true
        write                 = true
        retention_policy_days = 8
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

      hour_metrics = {
        version               = "1.0"
        enabled               = true
        include_apis          = true
        retention_policy_days = 8
      }
    }

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

    policy = {
      sas = {
        expiration_action = "Log"
        expiration_period = "07.05:13:22"
      }
    }

    routing = {
      publish_internet_endpoints = true
    }

    mgt_policies = {
      rules = {
        rule_1 = {
          name    = "rule1"
          enabled = true
          filters = {
            filter_specs = {
              prefix_match = ["container1/prefix1"]
              blob_types   = ["blockBlob"]
            }
          }
          actions = {
            base_blob = {
              blob_specs = {
                tier_to_cool_after_days_since_modification_greater_than    = 11
                tier_to_archive_after_days_since_modification_greater_than = 51
                delete_after_days_since_modification_greater_than          = 101
              }
            }
            snapshot = {
              snapshot_specs = {
                change_tier_to_archive_after_days_since_creation = 90
                change_tier_to_cool_after_days_since_creation    = 23
                delete_after_days_since_creation_greater_than    = 31
              }
            }
            version = {
              version_specs = {
                change_tier_to_archive_after_days_since_creation = 9
                change_tier_to_cool_after_days_since_creation    = 90
                delete_after_days_since_creation                 = 3
              }
            }
          }
        },
        rule_2 = {
          name    = "rule2"
          enabled = true
          filters = {
            filter_specs = {
              prefix_match = ["container1/prefix3"]
              blob_types   = ["blockBlob"]
            }
          }
          actions = {
            base_blob = {
              blob_specs = {
                tier_to_cool_after_days_since_last_access_time_greater_than    = 30
                tier_to_archive_after_days_since_last_access_time_greater_than = 90
                delete_after_days_since_last_access_time_greater_than          = 365
                auto_tier_to_hot_from_cool_enabled                             = true
              }
            }
          }
        }
      }
    }
    queues = {
      q1 = {
        name = "queue1"
      }
    }

    containers = {
      sc1 = { name = "mystore250", access_type = "private" }
    }

    shares = {
      fs1 = { name = "smbfileshare1", quota = 50 }
      fs2 = { name = "smbfileshare2", quota = 10 }
    }
  }
}
