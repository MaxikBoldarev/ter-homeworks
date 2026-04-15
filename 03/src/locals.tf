locals {
  # Считываем SSH ключ через функцию file
  ssh_key = file("~/.ssh/id_ed25519.pub")
  
  # Общие метаданные для всех ВМ
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}
