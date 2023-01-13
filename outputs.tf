output "sa" {
  value = azurerm_storage_account.sa
}

output "merged_ids" {
  value = values(azurerm_storage_account.sa)[*].id
}

output "endpoints" {
  value = azurerm_private_endpoint.endpoint
}