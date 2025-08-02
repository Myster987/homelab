output "hostname" {
  description = "List of VM names"
  value       = [for vm in proxmox_vm_qemu.talos-vms : { (vm.name) : vm.default_ipv4_address }]
}
