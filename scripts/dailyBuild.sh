#!/bin/bash
while getopts t:d:b:u: flag;
do
    case "${flag}" in
        t) DATE="${OPTARG}";;
        d) DRIVER="${OPTARG}";;
        b) BUILD="${OPTARG}";;
        u) DOCKER_USERNAME="${OPTARG}"
    esac
done

echo "Testing daily build image"

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/"$DATE"/"$DRIVER"</runtimeUrl></install></configuration>" system/pom.xml inventory/pom.xml
cat system/pom.xml
cat inventory/pom.xml

sed -i "s;FROM openliberty/open-liberty:kernel-java8-openj9-ubi;FROM "$DOCKER_USERNAME"/olguides:"$BUILD";g" system/Dockerfile inventory/Dockerfile
cat system/Dockerfile
cat inventory/Dockerfile

sudo ../scripts/testApp.sh

kubectl delete -f kubernetes.yaml
eval $(minikube docker-env -u)
minikube stop
minikube delete

echo "Testing daily Docker image"

sed -i "s;FROM openliberty/open-liberty:kernel-java8-openj9-ubi;FROM openliberty/daily:latest;g" system/Dockerfile inventory/Dockerfile

cat Dockerfile

docker pull "openliberty/daily:latest"

../scripts/testApp.sh
