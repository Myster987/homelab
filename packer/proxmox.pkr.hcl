packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "talos_version" {
  type    = string
  default = "v1.10.5"
}

variable "arch" {
  type    = string
  default = "amd64"
}

locals {
    timestamp = timestamp()
    disk_storage = "local-lvm"
    # image = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${var.talos_version}/nocloud-${var.arch}.iso"
    raw_image     = "nocloud-${var.arch}.raw"
}

source "proxmox-iso" "talos" {
    proxmox_url              = "${var.proxmox_url}"
    username                 = "${var.proxmox_username}"
    token                    = "${var.proxmox_token}"
    insecure_skip_tls_verify = true

    node                     = "${var.proxmox_nodename}"
    vm_id                    = "9000"
    vm_name                  = "talos-template-amd64"

    template_name = "talos-template-${var.talos_version}-qemu"
    template_description = "${local.timestamp} - Talos ${var.talos_version} template" 

    boot_wait = "25s"

    boot_iso {
        # type        = "virtio"
        iso_file    = "local:iso/talos-nocloud-${var.arch}.iso"
        unmount = false # for some reason when setting unmount to true cloned vm wouldn't boot
        iso_checksum = "none" # integrity is already checked at downlaod (https://github.com/siderolabs/image-factory/issues/184)
    }

    qemu_agent      = true
    scsi_controller = "virtio-scsi-single"
    # boot = "order=scsi0;  net0"


    disks {
      disk_size    = "114G"
      format       = "raw"
      storage_pool = local.disk_storage
      # type         = "virtio"
      type         = "scsi"
      ssd = true
    }


    cores        = 4
    cpu_type     = "x86-64-v2-AES"

    memory       = 8192 
    ballooning_minimum = 4096   

    network_adapters {
        model    = "virtio"
        bridge   = "vmbr0"
    }

    communicator = "none"
}

build {
    name    = "talos-template"
    sources = ["source.proxmox-iso.talos"]
}
