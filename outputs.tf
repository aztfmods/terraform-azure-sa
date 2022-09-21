output "sa" {
  value = azurerm_storage_account.sa
}

output "merged_ids" {
  value = values(azurerm_storage_account.sa)[*].id
}