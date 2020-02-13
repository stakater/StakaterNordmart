#!/bin/bash

DOMAIN="stakater-200205-1-5c84fa685b23fe4798253ee758d532d0-0000.eu-de.containers.appdomain.cloud"
UNIQUE_STRING=$(head /dev/urandom | tr -dc a-za-z0-9 | head -c 4)

read -p "Enter Namespace name: " NAMESPACE_NAME
NAMESPACE_NAME="$NAMESPACE_NAME-$UNIQUE_STRING"

echo "Namespace: $NAMESPACE_NAME"

#Replace DOMAIN placeholder
find . -type f -name "*.yaml" -print0 | xargs -0 sed -i "s|DOMAIN|${DOMAIN}|g"
find . -type f -name "*.json" -print0 | xargs -0 sed -i "s|DOMAIN|${DOMAIN}|g"

#Replace NAMESPACE placeholder
find . -type f -name "*.yaml" -print0 | xargs -0 sed -i "s|NAMESPACE|${NAMESPACE_NAME}|g"
find . -type f -name "*.json" -print0 | xargs -0 sed -i "s|NAMESPACE|${NAMESPACE_NAME}|g"

#Replace KEYCLOAK_CONFIG
KEYCLOAK_CONFIG=`cat configs/keycloak.json | base64 -w 0`
sed -i "s|KEYCLOAK_CONFIG|${KEYCLOAK_CONFIG}|g" secrets/secret-keycloak-config.yaml

#Create namespace
oc create namespace $NAMESPACE_NAME

#Fix permission issue on openshift
oc adm policy add-scc-to-user privileged system:serviceaccount:$NAMESPACE_NAME:default

#Apply manifests
oc apply -f secrets/ --namespace=$NAMESPACE_NAME
oc apply -R -f . --namespace=$NAMESPACE_NAME