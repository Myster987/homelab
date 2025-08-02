# main varaibles
variable "proxmox_token_id" {
  type = string
  # default = env("PROXMOX_TOKEN_ID")
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
  # default   = env("PROXMOX_TOKEN_SECRET")
}

variable "proxmox_url" {
  type = string
  # default = env("PROXMOX_URL")
}

variable "proxmox_nodename" {
  type = string
  # default = env("PROXMOX_NODE_NAME")
}

# vm module varaibles
variable "vm_count" {
  type    = number
  default = 1
}

variable "vm_id" {
  type = number
}

variable "vm_name" {
  type = string
}

variable "vm_desc" {
  type = string
}

variable "vm_target_node" {
  type = string
}

variable "vm_template_id" {
  type = string
}

variable "vm_cpu_count" {
  type = number
}

variable "vm_memory" {
  type = number
}

variable "vm_balloon" {
  type = number
}

variable "vm_disk_size" {
  type = number
}

variable "vm_bridge" {
  type    = string
  default = "vmbr0"
}
