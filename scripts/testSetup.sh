echo Set up Minikube
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo ln -s $(pwd)/kubectl /usr/local/bin/kubectl
wget https://github.com/kubernetes/minikube/releases/download/v0.28.2/minikube-linux-amd64 -q -O minikube
chmod +x minikube

echo Install Conn Track 
sudo apt-get update -y
sudo apt-get install -y conntrack

echo Start Minikube
sudo minikube start --vm-driver=none --bootstrapper=kubeadm
