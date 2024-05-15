#!/bin/bash -x
apt-get update

cat > /ingress.yaml<< EOF
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
spec:
  ingressClassName: nginx
  rules:
    - host: sebastienk-vm.francecentral.cloudapp.azure.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: frontend
                port:
                  number: 80
EOF

cat > /kind-config.yaml<< EOF
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
    - containerPort: 80
      hostPort: 80
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      protocol: TCP
- role: worker
- role: worker
EOF

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo usermod -aG docker sebastien

# Install Kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Install Kubectl
sudo snap install kubectl --classic

# Clone repo Microservices
git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git

sudo mkdir .kube
sudo adduser --gecos '' --disabled-password kind

kind create cluster --config /kind-config.yaml --kubeconfig /.kube/config

sudo chmod 660 /.kube/config
sudo chown -R kind: /.kube/

kubectl apply -f /microservices-demo/release/kubernetes-manifests.yaml --kubeconfig /.kube/config

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --kubeconfig /.kube/config

sleep 100
kubectl apply -f /ingress.yaml --kubeconfig /.kube/config