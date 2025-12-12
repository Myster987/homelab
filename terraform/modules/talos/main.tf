locals {
  storage = "local-lvm"
}

# VMs to deploy Talos Linux on Proxmox
resource "proxmox_vm_qemu" "talos-vm" {
  # vm metadata
  vmid        = var.id
  name        = var.name
  target_node = var.target_node

  vm_state = "stopped"
  agent    = 1 # qemu agent enabled
  boot     = "order=virtio0;ide2;net0"
  onboot   = true

  # hardware
  cpu {
    cores   = var.cpu_count
    sockets = 1
  }
  memory  = var.memory
  balloon = var.balloon

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/talos-amd64.iso"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = var.disk_size
          storage = local.storage
        }
      }
    }
  }

  network {
    id      = 0
    bridge  = var.bridge
    macaddr = var.macaddr
    tag     = var.tag
    model   = "virtio"
  }
}

output "name" {
  value = var.name
}

output "id" {
  value = var.id
}

output "mac" {
  value = var.macaddr
}
