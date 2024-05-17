output "Connect_ssh_vm_test" {
  value = [for user_name, user_value in local.users : "${user_name} : ssh -i ~/.ssh/${user_value.private_key} ${user_name}@${module.vm.vm_fqdn} "]
}

output "Test_fqdn" {
  value = " http://${module.vm.vm_fqdn} "
}

output "Prod_fqdn" {
  value = " https://${module.gateway.gateway_fqdn} "
}

output "Grab_credentials_AKS" {
  value = " az aks get-credentials --resource-group ${local.resource_group} --name ${module.aks.cluster_name} -f ~/.kube/config --overwrite-existing "
}