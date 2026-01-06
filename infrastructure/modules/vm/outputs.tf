
output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "ssh_private_key_pem" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "ssh_public_key_openssh" {
  value = tls_private_key.ssh.public_key_openssh
}