/*
 * # Helm Release - cert-manager
 *
 * Terraform module to deploy cert-manager on an AKS cluster.
 *
 */

resource "helm_release" "main" {
  name             = var.name
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "clusterissuer_letsencrypt_prod" {
  count = var.deploy_letsencrypt_issuer ? 1 : 0
  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "email" = var.letsencrypt_email
        "privateKeySecretRef" = {
          "name" = "letsencrypt"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "azure/application-gateway"
              }
            }
          },
        ]
      }
    }
  })
  lifecycle {
    precondition {
      condition     = var.deploy_letsencrypt_issuer == true && var.letsencrypt_email != null
      error_message = "You must provider an email address to deploy the lets encrypt issuer."
    }
  }
  depends_on = [helm_release.main]
}
