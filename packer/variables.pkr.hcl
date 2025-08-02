variable "proxmox_username" {
    type = string
    default = env("PROXMOX_TOKEN_ID")
}

variable "proxmox_token" {
    type = string
    sensitive = true
    default = env("PROXMOX_TOKEN_SECRET")
}

variable "proxmox_url" {
    type = string
    default = env("PROXMOX_URL")
}

variable "proxmox_nodename" {
    type = string
    default = env("PROXMOX_NODE_NAME")
}

variable "gateway" {
    type = string
    default = env("GATEWAY")
}
