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

printf "\ncurl http://`minikube ip`:31000/api/name\n"
curl http://`minikube ip`:31000/api/name

printf "\ncurl http://`minikube ip`:32000/api/ping/name-service\n"
curl http://`minikube ip`:32000/api/ping/name-service

printf "\nmvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`\n"
mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)\n"
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)

printf "\nkubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)\n" 
kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)
