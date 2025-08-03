locals {
  storage = "local-lvm"
}

# VMs to deploy Talos Linux on Proxmox
resource "proxmox_vm_qemu" "talos-vms" {
  count = var.instances_count

  # vm metadata
  vmid        = var.id + count.index
  name        = "${var.name}-${count.index + 1}"
  description = var.desc
  agent       = 1 # qemu agent enabled

  boot        = "order=virtio0;ide2;net0"
  onboot      = true
  target_node = var.target_node
  # template id
  clone      = var.template_id
  full_clone = true

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
          iso = "local:iso/talos-metal-amd64.iso"
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
    # scsi {
    #   scsi0 {
    #     disk {
    #       size    = var.disk_size
    #       storage = local.storage
    #     }
    #   }
    # }
  }

  network {
    id     = 0
    bridge = var.bridge
    model  = "virtio"
  }
}
