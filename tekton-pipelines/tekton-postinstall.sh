#!/bin/bash
oc adm policy add-scc-to-user anyuid -z tekton-pipelines-controller
sleep 5
kubectl get pods --namespace tekton-pipelines --watch