# Получаем образы для каждой ВМ БД
data "yandex_compute_image" "ubuntu_db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }
  family   = each.value.image_family
}
 
# Создаём ВМ для БД с помощью for_each
resource "yandex_compute_instance" "db" {
  # Преобразуем list в map для for_each
  for_each = { for vm in var.each_vm : vm.vm_name => vm }
 
  name        = each.value.vm_name
  platform_id = "standard-v1"
  zone        = var.default_zone
 
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }
 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db[each.key].image_id
      size     = each.value.disk_volume
    }
  }
 
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
 
  scheduling_policy {
    preemptible = true
  }
 
  metadata = local.metadata
}
