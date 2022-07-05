#!/bin/bash

# Set up and start Minikube
#curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
#chmod +x kubectl
#ln -s -f "$(pwd)/kubectl" "/usr/local/bin/kubectl"
#wget https://github.com/kubernetes/minikube/releases/download/v0.28.2/minikube-linux-amd64 -q -O minikube
#chmod +x minikube

apt-get update -y
apt-get install -y conntrack

sysctl fs.protected_regular=0

#eval "$(minikube docker-env -u)"
#minikube stop
#minikube delete

#minikube start --driver=none --bootstrapper=kubeadm
#eval "$(minikube docker-env)"


VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
echo "$VER"
wget "https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz"
tar xvf "cri-dockerd-${VER}.amd64.tgz"
mv cri-dockerd/cri-dockerd /usr/local/bin/
cri-dockerd --version
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
mv cri-docker.socket cri-docker.service /etc/systemd/system/
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

VERSION="v1.24.2"
wget "https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz"
sudo tar zxvf "crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin"
rm -f "crictl-$VERSION-linux-amd64.tar.gz"

systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket

minikube stop
minikube delete
minikube start --driver=none
