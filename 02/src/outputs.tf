output "info" {
  value = [
    {
      instance_name = var.vm_web_netology-develop-platform-web
      external_ip  = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn = yandex_compute_instance.platform.fqdn
    },
    {
      instance_name = var.vm_db_netology-develop-platform-db
      external_ip  = yandex_compute_instance.platform-db.network_interface[0].nat_ip_address
      fqdn = yandex_compute_instance.platform-db.fqdn
    }
  ]
}
