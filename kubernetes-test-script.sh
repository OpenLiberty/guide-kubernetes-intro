#!/bin/bash

echo "mvn -q package"
mvn -q package

echo "kubectl apply -f kubernetes.yaml"
kubectl apply -f kubernetes.yaml

echo "sleep 120"
sleep 120

echo "kubectl get pods"
kubectl get pods

echo "minikube ip"
echo `minikube ip`

echo "curl http://`minikube ip`:31000/api/name"
curl http://`minikube ip`:31000/api/name

echo "curl http://`minikube ip`:32000/api/ping/name-service"
curl http://`minikube ip`:32000/api/ping/name-service

echo "mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`"
mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`

echo "kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)"
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)

echo "kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)" 
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)
