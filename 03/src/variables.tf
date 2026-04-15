###cloud vars
variable "token" {
  type        = string
  default     = "y0__xDlqrK5ARjB3RMgu5bmihe7acX1WU1y0l31YHovwJGPwoKYEg"
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gl063l61mv7tlhn9s6"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gcubbb1rnu0uneu44c"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "web_vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образов для веб-серверов"
}
 
variable "web_vm_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
  })
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
    disk_size     = 10
  }
  description = "Ресурсы для веб-серверов"
}
 
# Переменная для for_each ВМ (базы данных)
variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
    image_family  = string
  }))
  default = [
    {
      vm_name       = "main"
      cpu           = 4
      ram           = 4
      disk_volume   = 20
      core_fraction = 20
      image_family  = "ubuntu-2004-lts"
    },
    {
      vm_name       = "replica"
      cpu           = 2
      ram           = 2
      disk_volume   = 10
      core_fraction = 5
      image_family  = "ubuntu-2004-lts"
    }
  ]
  description = "Параметры ВМ для баз данных"
}
