#!/bin/bash

# Set up and start Minikube
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
ln -s -f "$(pwd)/kubectl" "/usr/local/bin/kubectl"
#wget https://github.com/kubernetes/minikube/releases/download/v0.28.2/minikube-linux-amd64 -q -O minikube
#chmod +x minikube

apt-get update -y
apt-get install -y conntrack

sysctl fs.protected_regular=0

minikube start --driver=none --bootstrapper=kubeadm
#eval "$(minikube docker-env)"
