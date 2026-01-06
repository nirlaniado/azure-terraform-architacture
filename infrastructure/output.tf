output "app_public_ip" {
  value = module.app_vm.public_ip
}

output "flask_url" {
  value = "http://${module.app_vm.public_ip}:5000"
}
