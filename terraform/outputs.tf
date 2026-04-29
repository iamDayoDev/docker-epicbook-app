# Resources Output
output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "admin_user" {
  value = var.admin_username
}
