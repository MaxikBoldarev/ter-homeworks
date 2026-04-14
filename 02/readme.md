Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия Terraform =1.5.Х (версия 1.6.Х может вызывать проблемы с Яндекс провайдером)

Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
Создайте сервисный аккаунт и ключ. service_account_key_file.
Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address". Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: eval $(ssh-agent) && ssh-add Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.

В качестве решения приложите:

скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
ответы на вопросы.

Ответ
<img width="2253" height="71" alt="image" src="https://github.com/user-attachments/assets/81cc654f-013d-46dd-9b4a-ee0445b06b7a" /> Версия платформы и синтаксическая ошибка в слове

<img width="2486" height="87" alt="image" src="https://github.com/user-attachments/assets/f6f2d31a-9fa1-4557-b95c-113d225b80bf" /> Некорректно указаны ядра,не соотвествуют диапазону

<img width="1277" height="97" alt="image" src="https://github.com/user-attachments/assets/7f200050-382b-4632-b5c3-631c9a41f10a" />

<img width="410" height="48" alt="image" src="https://github.com/user-attachments/assets/8ec749be-4aa0-442b-b5c8-5f6415f79419" />


preemptible = true.
Прерываемые виртуальные машины — это виртуальные машины, которые могут быть принудительно остановлены в любой момент. Это может произойти в двух случаях:
Если с момента запуска виртуальной машины прошло 24 часа.
Если возникнет нехватка ресурсов для запуска обычной виртуальной машины в той же зоне доступности.
core_fraction=5
Выбранный уровень производительности. Этот уровень определяет долю вычислительного времени физических ядер, которую гарантирует vCPU.
Эти функции позволят снизить затраты при использование облака в обучении.


Задание 2

Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ .  Пример: vm_web_name.
Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
Проверьте terraform plan. Изменений быть не должно.

Ответ
<img width="1281" height="400" alt="image" src="https://github.com/user-attachments/assets/e92c994c-6a89-4015-aee3-588504aa284f" />

main.ft

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_ubuntu-2004-lts
}

resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_netology-develop-platform-web
  platform_id = var.vm_web_standard-v1
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

variables.ft

variable "vm_web_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image ubuntu-2004-lts"
}

variable "vm_web_netology-develop-platform-web" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name-platform-vm"
}

variable "vm_web_standard-v1" {
  type        = string
  default     = "standard-v1"
  description = "platform-id"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_web_memory" { 
  type        = number
  default     = 1
  description = "memory"
}

variable "vm_web_core_fraction" { 
  type        = number
  default     = 5
  description = "fraction"
}



Задание 3

Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" ,  cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
Примените изменения.

Ответ
<img width="887" height="183" alt="image" src="https://github.com/user-attachments/assets/3e86032e-4fdb-4a41-85b4-3524228715ea" />
<img width="1722" height="350" alt="image" src="https://github.com/user-attachments/assets/ae0e34df-06a7-4e5c-b7fb-3197c0f2307f" />


vms_platform.tf


variable "vm_db_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image db ubuntu-2004-lts"
}

variable "vm_db_netology-develop-platform-db" {
  type        = string
  default     = "netology-develop-platform-db"
}

variable "vm_db_standard-v1" {
  type        = string
  default     = "standard-v1"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_db_memory" { 
  type        = number
  default     = 2
  description = "memory"
}

variable "vm_db_core_fraction" { 
  type        = number
  default     = 20
  description = "fraction"
} 

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-db"
  description = "VPC network & subnet name"
}

Задание 4

Объявите в файле outputs.tf один output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.
Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды terraform output.
Ответ

<img width="887" height="400" alt="image" src="https://github.com/user-attachments/assets/af3d0b6e-4ed1-4f83-a580-7f74dfc09e84" />


Задание 5

В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
Примените изменения.

Ответ
<img width="1253" height="758" alt="image" src="https://github.com/user-attachments/assets/06dd3faa-be5b-43ff-b6ee-4af95fad0c6e" />

### Задание 6


Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную vms_resources и  внутри неё конфиги обеих ВМ в виде вложенного map.
пример из terraform.tfvars:
vms_resources = {
  web={
    cores=
    memory=
    core_fraction=
    ...
  },
  db= {
    cores=
    memory=
    core_fraction=
    ...
  }
}


Создайте и используйте отдельную map переменную для блока metadata, она должна быть общая для всех ваших ВМ.
пример из terraform.tfvars:
metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
}


Найдите и закоментируйте все, более не используемые переменные проекта.


Проверьте terraform plan. Изменений быть не должно.


## Ответ
variable "metadatas" {
  type = map
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 !!!!!!!!!!!!!!!!!!!"
    }
}

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))
  default = {
    web = {
      cores = 2
      memory = 1
      core_fraction = 5
    },
    db = {
      cores = 2
      memory = 2
      core_fraction = 20
    }
  }
}

