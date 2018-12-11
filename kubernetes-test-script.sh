#!/bin/bash

printf "\nmvn -q package"
mvn -q package

printf "\nkubectl apply -f kubernetes.yaml"
kubectl apply -f kubernetes.yaml

printf "\nsleep 120"
sleep 120

printf "\nkubectl get pods"
kubectl get pods

printf "\nminikube ip"
echo `minikube ip`

printf "\ncurl http://`minikube ip`:31000/api/name"
curl http://`minikube ip`:31000/api/name

printf "\ncurl http://`minikube ip`:32000/api/ping/name-service"
curl http://`minikube ip`:32000/api/ping/name-service

printf "\nmvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`"
mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)"
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)" 
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)
