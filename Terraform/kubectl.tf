resource "time_sleep" "wait_90_seconds" {
  depends_on = [module.helm]

  create_duration = "90s"
}

resource "kubectl_manifest" "test" {
    depends_on = [ time_sleep.wait_90_seconds ]
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  namespace: onlineboutique
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
    cert-manager.io/cluster-issuer: ${module.cert_manager.kubectl_manifest.name}
    cert-manager.io/acme-challenge-type: http01
spec:
  tls:
  - hosts:
      - sebastienk-gateway.francecentral.cloudapp.azure.com
    secretName: tls-secret
  rules:
    - host: sebastienk-gateway.francecentral.cloudapp.azure.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: frontend
                port:
                  number: 80
YAML
}                  