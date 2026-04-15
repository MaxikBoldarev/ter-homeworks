# Создаём 3 одинаковых диска по 1 Гб с помощью count
resource "yandex_compute_disk" "storage_disks" {
  count = 3
 
  name = "disk-${count.index + 1}"
  size = 1       # 1 Гб
  zone = var.default_zone
  type = "network-hdd"
}
 
# Получаем образ для storage ВМ
data "yandex_compute_image" "ubuntu_storage" {
  family = var.web_vm_image_family
}
 
# Одиночная ВМ "storage" (count и for_each запрещены!)
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone
 
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_storage.image_id
      size     = 10
    }
  }
 
  # Динамическое подключение дополнительных дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks[*].id
    content {
      disk_id = secondary_disk.value
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
