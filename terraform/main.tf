provider "proxmox" {
  pm_tls_insecure = true
}

module "vm" {
  source = "./modules/talos"

  for_each = { for n in var.nodes : n.name => n }

  # per vm config
  id          = each.value.id
  name        = each.value.name
  target_node = each.value.target_node
  macaddr     = each.value.macaddr

  # shared config
  cpu_count = var.vm_cpu_count
  memory    = var.vm_memory
  balloon   = var.vm_balloon
  disk_size = var.vm_disk_size
  bridge    = var.vm_bridge
  tag       = var.vm_vlan_tag
  # cloud_init_user     = "mikolaj"
  # cloud_init_password = "test"
}

output "VMs" {
  value = {
    for name, vm in module.vm :
    name => {
      id   = vm.id
      name = vm.name
      mac  = vm.mac
    }
  }
}
