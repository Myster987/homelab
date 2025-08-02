provider "proxmox" {
  pm_api_url          = var.proxmox_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret

  pm_tls_insecure = true
}

module "vm" {
  source = "./modules/vm"

  instances_count = var.vm_count

  id   = var.vm_id
  name = var.vm_name
  desc = var.vm_desc

  target_node = var.vm_target_node
  template_id = var.vm_template_id

  cpu_count = var.vm_cpu_count
  memory    = var.vm_memory
  balloon   = var.vm_balloon
  disk_size = var.vm_disk_size
}

output "VMs" {
  value = [for m in module.vm : m]
}
