#!/bin/bash

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash


#install docker

# sudo apt  install docker.io -y
# sudo chmod 777 /var/run/docker.sock

# Install kubectl
curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
kubectl version --client

# helm install

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

sudo apt install net-tools -y

# non-interactive or headless installation
export AUTO_INSTALL=y
export ENDPOINT=$(curl ifconfig.me && echo "" )
export APPROVE_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export PORT_CHOICE=1
export PROTOCOL_CHOICE=2
export DNS=1
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
export CLIENT=srikanth
export PASS=1
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
./openvpn-install.sh

# az aks get-credentials --name myaksCluster-eastus --resource-group myRG
# alias k=kubectl
# git clone https://github.com/srikanthhg/azure-bicep-files.git
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm upgrade --install my-ingress-nginx ingress-nginx/ingress-nginx --version 4.13.2 -f  ./azure-bicep-files/app-of-apps/chart-value-files/ingress-nginx/ingress-values.yaml
# helm repo add argo https://argoproj.github.io/argo-helm
# helm upgrade --install my-argo-cd argo/argo-cd --version 8.3.1 -f ./azure-bicep-files/argocd-custom-values.yaml --create-namespace --namespace argocd