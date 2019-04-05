#!/bin/bash
set -euxo pipefail

##############################################################################
##
##  Travis CI test script
##
##############################################################################

mvn -q package

kubectl apply -f kubernetes.yaml

sleep 120

kubectl get pods

echo `minikube ip`

curl http://`minikube ip`:31000/api/name

curl http://`minikube ip`:32000/api/ping/name-service

mvn verify -Ddockerfile.skip=true -Dcluster.ip=`minikube ip`

kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep name)

kubectl logs $(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep ping)
