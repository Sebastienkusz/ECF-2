output "helm_release" {
  value = helm_release.main
}

output "kubectl_manifest" {
  value = one(kubectl_manifest.clusterissuer_letsencrypt_prod[*])
}
