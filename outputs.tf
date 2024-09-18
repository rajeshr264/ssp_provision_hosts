# Generate Puppet Bolt inventory.yaml file
resource "local_file" "bolt_inventory" {
  filename = "./hosts_inventory.yaml"

  content = templatefile("./inventory.tpl", {
    instances = proxmox_virtual_environment_vm.vm[*].ipv4_addresses[1][0],
    ssh_private_key_filename = var.host_private_key_filename,
    ssh_username = var.host_username
  })
}