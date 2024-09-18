data "local_file" "host_public_key_filename" {
  filename = var.host_public_key_filename
}

# random number range
resource "random_integer" "rand" {
  min = 5000
  max = 9000
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = "node-${count.index + 1}"
  node_name = var.proxmox_node_name
  count = var.number_of_hosts

  initialization {

    ip_config {
      ipv4 {
       address = "dhcp"
      }
    }

    user_account {
      username = var.host_username
      keys     = [trimspace(data.local_file.host_public_key_filename.content)]
      password = var.host_password
    }
  }

  clone{
    vm_id = var.proxmox_machine_image_template_id
    full = true 
  }

  network_device {
    bridge = var.proxmox_network_bridge_name
  }
}

# Run a local post-install script that checks if the bastion host is up and running
# resource "null_resource" "check_host_ready" {
#   provisioner "local-exec" {
#     command = "./scripts/check_host_ready.sh ${proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]} ${var.host_private_key_filename} ${var.host_username}"
#   }
#   depends_on = [proxmox_virtual_environment_vm.vm]
# }

