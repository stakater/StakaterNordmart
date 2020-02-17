read -p "Enter Namespace name: " NAMESPACE_NAME
echo "Namespace: $NAMESPACE_NAME"

oc delete -n $NAMESPACE_NAME -f apps/
oc delete -n $NAMESPACE_NAME -f secrets
oc delete -n $NAMESPACE_NAME -f .
oc delete project $NAMESPACE_NAME
