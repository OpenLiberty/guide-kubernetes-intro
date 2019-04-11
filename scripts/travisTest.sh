#!/bin/bash

##############################################################################
##
##  Travis CI test script
##
##############################################################################

printf "\nmvn -q package\n"
mvn -q package

printf "\nkubectl apply -f kubernetes.yaml\n"
kubectl apply -f kubernetes.yaml

printf "\nsleep 120\n"
sleep 120

printf "\nkubectl get pods\n"
kubectl get pods

printf "\nminikube ip\n"
echo `minikube ip`

printf "\ncurl http://`minikube ip`:31000/system/properties\n"
curl http://`minikube ip`:31000/system/properties

printf "\ncurl http://`minikube ip`:32000/inventory/systems\n"
curl http://`minikube ip`:32000/inventory/systems

printf "\nmvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`\n"
mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep system)\n"
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep system)

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep inventory)\n" 
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep inventory)
