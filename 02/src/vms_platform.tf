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

#variable "vm_db_cores" {
#  type        = number
#  default     = 2
#  description = "cores"
#}

#variable "vm_db_memory" { 
#  type        = number
#  default     = 2
#  description = "memory"
#}

#variable "vm_db_core_fraction" { 
#  type        = number
#  default     = 20
#  description = "fraction"
#} 

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

######
variable "metadatas" {
  type = map
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBUbSOp30Ned3kYwDluEK6naOSSbKCAhW7VRyuABv94S maxikboldarev13@yandex.ru"
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

