#!/bin/bash
set -euxo pipefail

# Set up and start Minikube
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo ln -s -f $(pwd)/kubectl /usr/local/bin/kubectl
wget https://github.com/kubernetes/minikube/releases/download/v0.28.2/minikube-linux-amd64 -q -O minikube
chmod +x minikube
CHANGE_MINIKUBE_NONE_USER=true

sudo apt-get update -y
sudo apt-get install -y conntrack

sudo minikube start --vm-driver=none --bootstrapper=kubeadm

mvn -q package

docker pull openliberty/open-liberty:kernel-java8-openj9-ubi

docker build -t system:1.0-SNAPSHOT system/.
docker build -t inventory:1.0-SNAPSHOT inventory/.

kubectl apply -f kubernetes.yaml

sleep 120

kubectl get pods

echo $(minikube ip)

curl http://`minikube ip`:31000/system/properties
curl http://`minikube ip`:32000/inventory/systems

mvn failsafe:integration-test -Ddockerfile.skip=true -Dcluster.ip=$(minikube ip)
mvn failsafe:verify

kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep system)
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep inventory)
