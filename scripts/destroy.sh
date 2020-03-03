echo "Namespace: NAMESPACE_NAME"

kubectl delete -n NAMESPACE_NAME -f apps/
kubectl delete -n NAMESPACE_NAME -f secrets
kubectl delete -n NAMESPACE_NAME -f .
