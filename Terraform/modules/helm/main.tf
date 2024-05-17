# Application Google Online Boutique
resource "helm_release" "google_ob" {
  name             = var.google_ob_name
  chart            = var.google_ob_chart
  create_namespace = var.google_ob_namespace_creation
  namespace        = var.google_ob_namespace
  version          = var.google_ob_version
}

# Install nginx ingress controller form helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
resource "helm_release" "ingress-azure" {
  repository       = var.ingress_repository
  chart            = var.ingress_chart
  name             = var.ingress_name
  namespace        = var.ingress_namespace
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  skip_crds        = true
  create_namespace = var.ingress_namespace_creation
  version          = "1.7.2"

  set {
    name  = "appgw.subscriptionId"
    value = var.subscription_id
  }
  set {
    name  = "appgw.resourceGroup"
    value = var.resource_group
  }
  set {
    name  = "appgw.name"
    value = var.gateway_name
  }
  set {
    name  = "appgw.usePrivateIP"
    value = "false"
  }
  set {
    name  = "armAuth.type"
    value = "servicePrincipal"
  }
  set {
    name  = "armAuth.secretJSON"
    value = "ewogICJjbGllbnRJZCI6ICJlNTM1ODU1OS0wYmI5LTRmMDAtODY3Ny1jNjM2ODVkY2Y5ZDAiLAogICJjbGllbnRTZWNyZXQiOiAiWG9yOFF+d2tWbTBrZmh4ZmZaVzQ1SHF6TlRSR0FIUE5MOF9EYWFvcyIsCiAgInN1YnNjcmlwdGlvbklkIjogImM1NmFlYTJjLTUwZGUtNGFkYy05NjczLTZhODAwODg5MmMyMSIsCiAgInRlbmFudElkIjogIjE2NzYzMjY1LTE5OTgtNGM5Ni04MjZlLWMwNDE2MmIxZTA0MSIsCiAgImFjdGl2ZURpcmVjdG9yeUVuZHBvaW50VXJsIjogImh0dHBzOi8vbG9naW4ubWljcm9zb2Z0b25saW5lLmNvbSIsCiAgInJlc291cmNlTWFuYWdlckVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5henVyZS5jb20vIiwKICAiYWN0aXZlRGlyZWN0b3J5R3JhcGhSZXNvdXJjZUlkIjogImh0dHBzOi8vZ3JhcGgud2luZG93cy5uZXQvIiwKICAic3FsTWFuYWdlbWVudEVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5jb3JlLndpbmRvd3MubmV0Ojg0NDMvIiwKICAiZ2FsbGVyeUVuZHBvaW50VXJsIjogImh0dHBzOi8vZ2FsbGVyeS5henVyZS5jb20vIiwKICAibWFuYWdlbWVudEVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5jb3JlLndpbmRvd3MubmV0LyIKfQo=" #"$(az ad sp create-for-rbac --role Contributor --scope /subscriptions/${var.subscription_id} --sdk-auth | base64)"
  }
  set {
    name  = "rbac.enabled"
    value = "true"
  }
}

