#!/bin/bash
set -euxo pipefail

mvn -q package

docker pull openliberty/open-liberty:full-java11-openj9-ubi

docker build -t system:1.0-SNAPSHOT system/.
docker build -t inventory:1.0-SNAPSHOT inventory/.

NAMESPACE_NAME=$(bx cr namespace-list | grep sn-labs- | sed 's/ *$//g')
echo "${NAMESPACE_NAME}"
docker tag inventory:1.0-SNAPSHOT us.icr.io/"${NAMESPACE_NAME}"/inventory:1.0-SNAPSHOT
docker tag system:1.0-SNAPSHOT us.icr.io/"${NAMESPACE_NAME}"/system:1.0-SNAPSHOT
docker push us.icr.io/"${NAMESPACE_NAME}"/inventory:1.0-SNAPSHOT
docker push us.icr.io/"${NAMESPACE_NAME}"/system:1.0-SNAPSHOT

sed -i 's=system:1.0-SNAPSHOT=us.icr.io/'"${NAMESPACE_NAME}"'/system:1.0-SNAPSHOT=g' kubernetes.yaml
sed -i 's=inventory:1.0-SNAPSHOT=us.icr.io/'"${NAMESPACE_NAME}"'/inventory:1.0-SNAPSHOT=g' kubernetes.yaml

kubectl apply -f kubernetes.yaml

sleep 120

kubectl get pods

IPSTR=$(kubectl describe pod system | grep Node: | cut -c 15-)
IFS=/
read -r -a system_ip <<< "${IPSTR}"
curl http://"${system_ip[0]}":31000/system/properties

IPSTR=$(kubectl describe pod inventory | grep Node: | cut -c 15-)
read -r -a inventory_ip <<< "${IPSTR}"

curl http://"${inventory_ip[0]}":32000/inventory/systems

sed -i 's=localhost='"${inventory_ip[0]}"'=g' inventory/pom.xml
sed -i 's=localhost='"${system_ip[0]}"'=g' system/pom.xml

mvn failsafe:integration-test 
mvn failsafe:verify

kubectl logs "$(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep system)"
kubectl logs "$(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep inventory)"

kubectl delete -f kubernetes.yaml
