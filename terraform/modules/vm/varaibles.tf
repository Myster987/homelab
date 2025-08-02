variable "instances_count" {
  type = number
}

variable "id" {
  type = number
}

variable "name" {
  type = string
}

variable "desc" {
  type = string
}

variable "target_node" {
  type = string
}

variable "template_id" {
  type = string
}

variable "cpu_count" {
  type = number
}

variable "memory" {
  type = number
}

variable "balloon" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}
