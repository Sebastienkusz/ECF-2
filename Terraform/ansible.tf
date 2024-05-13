# Create inventory.ini for Ansible
resource "local_file" "inventory" {
  filename        = "${path.root}/../Ansible/inventory.ini"
  file_permission = "0644"
  content         = <<-EOT
[vm_test]
${module.vm.vm_fqdn}

[vm_test:vars]
ansible_port=22
ansible_ssh_private_key_file=./../Terraform/${local_file.admin_rsa_file.filename}

[all:vars]
ansible_connection=ssh
ansible_ssh_user=${local.admin_username}
ansible_become=true
EOT
}

resource "null_resource" "playbookconfig" {
  depends_on = [module.vm]
  provisioner "local-exec" {
    working_dir = "${path.root}/../Ansible"
    interpreter = ["bash", "-c"]
    command     = "sleep 100; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml -i inventory.ini"
  }
}