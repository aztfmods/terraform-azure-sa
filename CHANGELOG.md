# Changelog

## [1.9.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.8.0...v1.9.0) (2023-03-18)


### Features

* simplify structure ([#67](https://github.com/aztfmods/module-azurerm-sa/issues/67)) ([eb90b6e](https://github.com/aztfmods/module-azurerm-sa/commit/eb90b6ec11df9dd599af768510ece6c44f08f26c))

## [1.8.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.7.0...v1.8.0) (2023-02-18)


### Features

* add queue_properties support ([#59](https://github.com/aztfmods/module-azurerm-sa/issues/59)) ([4b369cf](https://github.com/aztfmods/module-azurerm-sa/commit/4b369cffd8e5fbf97cafe90d597f2cf6b4e1fd86))

## [1.7.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.6.0...v1.7.0) (2022-12-17)


### Features

* add blob_properties and cors_rule support ([#52](https://github.com/aztfmods/module-azurerm-sa/issues/52)) ([f84bcb9](https://github.com/aztfmods/module-azurerm-sa/commit/f84bcb90801808bfbb211617e228fb5d162718e7))
* add delete_retention_policy, container_delete_retention_policy and restore_policy support for blob service ([#55](https://github.com/aztfmods/module-azurerm-sa/issues/55)) ([33dfc81](https://github.com/aztfmods/module-azurerm-sa/commit/33dfc819f10d93c9aa83d5ceaf0f297c8a913600))
* add sftp_enabled support using conditional expressions ([#49](https://github.com/aztfmods/module-azurerm-sa/issues/49)) ([b4b3245](https://github.com/aztfmods/module-azurerm-sa/commit/b4b3245a3cee2c1192295c76d2f5d3bfec5da266))

## [1.6.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.5.0...v1.6.0) (2022-12-08)


### Features

* set defaults for account_tier, account_replication_type and account_kind arguments ([#48](https://github.com/aztfmods/module-azurerm-sa/issues/48)) ([bff3c50](https://github.com/aztfmods/module-azurerm-sa/commit/bff3c5018e547d95ad44e1dc95ed1c4ed0fe14b4))
* small refactor naming convention ([#46](https://github.com/aztfmods/module-azurerm-sa/issues/46)) ([59bf0d6](https://github.com/aztfmods/module-azurerm-sa/commit/59bf0d6e6ef034ba9cf73a9400176d38ae327bed))

## [1.5.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.4.0...v1.5.0) (2022-12-02)


### Features

* add initial probot config ([#25](https://github.com/aztfmods/module-azurerm-sa/issues/25)) ([18e9f15](https://github.com/aztfmods/module-azurerm-sa/commit/18e9f15b1271d99c17e36963820a395e80479d3a))
* add more examples ([#42](https://github.com/aztfmods/module-azurerm-sa/issues/42)) ([b3bb550](https://github.com/aztfmods/module-azurerm-sa/commit/b3bb5503248f9a1cd496beaf6c6bd1397fa6de1a))

## [1.4.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.3.0...v1.4.0) (2022-10-14)


### Features

* add management policy support ([#20](https://github.com/aztfmods/module-azurerm-sa/issues/20)) ([86d5634](https://github.com/aztfmods/module-azurerm-sa/commit/86d563422e62c4965a1a83f427bb9a5a78f40590))
* add more optional arguments ([#23](https://github.com/aztfmods/module-azurerm-sa/issues/23)) ([76fedab](https://github.com/aztfmods/module-azurerm-sa/commit/76fedaba3add21412f64d3c9566321e546eb4c5f))

## [1.3.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.2.0...v1.3.0) (2022-10-01)


### Features

* add reusable validation workflows ([#18](https://github.com/aztfmods/module-azurerm-sa/issues/18)) ([d5a06f2](https://github.com/aztfmods/module-azurerm-sa/commit/d5a06f2eadd99ab6c6eff75b525d248ff4bd52d6))

## [1.2.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.1.0...v1.2.0) (2022-09-25)


### Features

* add consistent naming ([#16](https://github.com/aztfmods/module-azurerm-sa/issues/16)) ([ad63207](https://github.com/aztfmods/module-azurerm-sa/commit/ad6320798f749f9f71a6daa00015b0c4f615c4b2))

## [1.1.0](https://github.com/aztfmods/module-azurerm-sa/compare/v1.0.1...v1.1.0) (2022-09-24)


### Features

* add more outputs ([#10](https://github.com/aztfmods/module-azurerm-sa/issues/10)) ([dad80f0](https://github.com/aztfmods/module-azurerm-sa/commit/dad80f0213d721e0febc8b82ab3a2b9ac691a3c6))
* small refactor resourcegroups ([#12](https://github.com/aztfmods/module-azurerm-sa/issues/12)) ([a454bef](https://github.com/aztfmods/module-azurerm-sa/commit/a454bef0d74e9ed3ad7c8832730a87dd38359afa))
* small update documentation ([#14](https://github.com/aztfmods/module-azurerm-sa/issues/14)) ([b789ecf](https://github.com/aztfmods/module-azurerm-sa/commit/b789ecf35c50d0686c4f4bb3f8b84420c00151a5))

## [1.0.1](https://github.com/dkooll/terraform-azurerm-storageaccount/compare/v1.0.0...v1.0.1) (2022-09-10)


### Bug Fixes

* change string to bool when enabling advanced protection ([#7](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/7)) ([6cc0a0d](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/6cc0a0d751ac9ad7c879dda2b391fb7662dad271))

## 1.0.0 (2022-09-08)


### Features

* add advanced threat protection ([#5](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/5)) ([6f5ff24](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/6f5ff241436dd3802b24ea3b28a8e47bb4d7153d))
* add documentation ([#6](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/6)) ([c7d5223](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/c7d522399c2bcdaa5ad578ee4819eb05759d63ab))
* add initial module ([#1](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/1)) ([65a1d1c](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/65a1d1c5738ac578aa729d3746960e12c6201c68))
* add optional containers ([#3](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/3)) ([813550f](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/813550f61482603418ca3c47e7ead3492fcf9d37))
* add terratest validation ([#4](https://github.com/dkooll/terraform-azurerm-storageaccount/issues/4)) ([0b7f038](https://github.com/dkooll/terraform-azurerm-storageaccount/commit/0b7f038b6ee70cb7d4b12d898920601f9c947295))
