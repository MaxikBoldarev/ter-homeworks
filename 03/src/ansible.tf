# Генерация inventory файла для Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${path.module}/hosts.tftpl",
    {
      # Группа веб-серверов (из задания 2.1)
      webservers = [
        for i in yandex_compute_instance.web : {
          name = i.name
          ip   = i.network_interface[0].nat_ip_address
          fqdn = i.fqdn
        }
      ]
 
      # Группа баз данных (из задания 2.2)
      databases = [
        for i in yandex_compute_instance.db : {
          name = i.name
          ip   = i.network_interface[0].nat_ip_address
          fqdn = i.fqdn
        }
      ]
 
      # Группа storage (из задания 3)
      storage = [
        {
          name = yandex_compute_instance.storage.name
          ip   = yandex_compute_instance.storage.network_interface[0].nat_ip_address
          fqdn = yandex_compute_instance.storage.fqdn
        }
      ]
    }
  )
 
  filename = "${path.module}/hosts.cfg"
 
  # Создаём файл после создания всех ВМ
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage
  ]
}
 
output "web_vms" {
  description = "Информация о веб-серверах"
  value = [
    for vm in yandex_compute_instance.web : {
      name        = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      internal_ip = vm.network_interface[0].ip_address
      fqdn        = vm.fqdn
    }
  ]
}
 
output "db_vms" {
  description = "Информация о серверах БД"
  value = {
    for k, vm in yandex_compute_instance.db : k => {
      name        = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      internal_ip = vm.network_interface[0].ip_address
      fqdn        = vm.fqdn
    }
  }
}
 
output "storage_vm" {
  description = "Информация о storage сервере"
  value = {
    name        = yandex_compute_instance.storage.name
    external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    internal_ip = yandex_compute_instance.storage.network_interface[0].ip_address
    fqdn        = yandex_compute_instance.storage.fqdn
  }
}
 
output "ansible_inventory_path" {
  description = "Путь к сгенерированному inventory файлу"
  value       = local_file.ansible_inventory.filename
}
