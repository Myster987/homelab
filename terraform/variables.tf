# main varaibles
# variable "proxmox_token_id" {
#   type = string
#   # default = env("PROXMOX_TOKEN_ID")
# }

# variable "proxmox_token_secret" {
#   type      = string
#   sensitive = true
#   # default   = env("PROXMOX_TOKEN_SECRET")
# }

# variable "proxmox_url" {
#   type = string
#   # default = env("PROXMOX_URL")
# }

# variable "proxmox_nodename" {
#   type = string
#   # default = env("PROXMOX_NODE_NAME")
# }

variable "nodes" {
  description = "List of Talos VM definitions"
  type = list(object({
    id          = number
    name        = string
    target_node = string
    macaddr     = string
  }))
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
  type = string
}

variable "vm_bridge" {
  type = string
}

variable "vm_vlan_tag" {
  type = number
}
