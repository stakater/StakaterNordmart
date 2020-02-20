#!/bin/bash

DOMAIN="nordmart.stakater.com"

read -p "Enter Namespace name: " NAMESPACE_NAME

echo "Namespace: $NAMESPACE_NAME"

#Replace DOMAIN placeholder
find . -type f -name "*.yaml" -print0 | xargs -0 perl -i -pe "s|DOMAIN|${DOMAIN}|g"
find . -type f -name "*.json" -print0 | xargs -0 perl -i -pe "s|DOMAIN|${DOMAIN}|g"

#Replace NAMESPACE placeholder
find . -type f -name "*.yaml" -print0 | xargs -0 perl -i -pe "s|NAMESPACE_NAME|${NAMESPACE_NAME}|g"
find . -type f -name "*.json" -print0 | xargs -0 perl -i -pe "s|NAMESPACE_NAME|${NAMESPACE_NAME}|g"
perl -i -pe "s|NAMESPACE_NAME|${NAMESPACE_NAME}|g" scripts/destroy.sh


#Create namespace
oc create namespace $NAMESPACE_NAME
oc label namespace $NAMESPACE_NAME prometheus=stakater-workload-monitoring

#Fix permission issue on openshift
oc adm policy add-scc-to-user anyuid system:serviceaccount:$NAMESPACE_NAME:default

#Apply secrets
oc apply -f secrets/ --namespace=$NAMESPACE_NAME 2>/dev/null

#Install kafka
oc apply -f kafka.yaml --namespace=$NAMESPACE_NAME

#Apply manifests
n=0
until [ $n -ge 2 ]
do
   oc apply -R -f . --namespace=$NAMESPACE_NAME 2>/dev/null && break
   n=$[$n+1]
   echo "Retrying for $n/2 times..."
done

echo "Front-end URL: web-$NAMESPACE_NAME.$DOMAIN"
echo "Gateway URL: gateway-$NAMESPACE_NAME.$DOMAIN"

#CURL gateway to retrieve catalog
CATALOG_STATUS=$(curl -X GET -IL https://gateway-$NAMESPACE_NAME.$DOMAIN/api/products 2>/dev/null | head -n 1 | cut -d ' ' -f2)
echo "Retrieve catalog status: $CATALOG_STATUS"

#Change namespace context
oc project $NAMESPACE_NAME