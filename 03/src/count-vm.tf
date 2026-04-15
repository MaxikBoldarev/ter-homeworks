# Получаем последний образ Ubuntu
data "yandex_compute_image" "ubuntu_web" {
  family = var.web_vm_image_family
}
 
# Создаём 2 одинаковые ВМ с помощью count
resource "yandex_compute_instance" "web" {
  count = 2
 
  name        = "web-${count.index + 1}"  # web-1, web-2
  platform_id = "standard-v1"
  zone        = var.default_zone
 
  # ВМ из п.2.1 создаются ПОСЛЕ ВМ из п.2.2
  depends_on = [yandex_compute_instance.db]
 
  resources {
    cores         = var.web_vm_resources.cores
    memory        = var.web_vm_resources.memory
    core_fraction = var.web_vm_resources.core_fraction
  }
 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
      size     = var.web_vm_resources.disk_size
    }
  }
 
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    # Назначаем группу безопасности из задания 1
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
 
  # Прерываемая ВМ для экономии средств
  scheduling_policy {
    preemptible = true
  }
 
  metadata = local.metadata
}
