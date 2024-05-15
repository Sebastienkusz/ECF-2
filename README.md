# ECF-2



kind create cluster --config /kind-config.yaml

kubectl apply -f /microservices-demo/release/kubernetes-manifests.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl apply -f /ingress.yaml