# bastion host inventory.yaml template for Puppet Bolt
groups:
 - name: hosts
   targets:
  %{ for ip in instances ~}
     - ${ip}
  %{ endfor ~}
   config:
     transport: ssh
     ssh:
       host-key-check: false
       native-ssh: true
       user: ${ssh_username}
       private-key: ${ssh_private_key_filename}
       run-as: root
