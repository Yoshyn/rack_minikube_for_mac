#!/bin/bash

kubectl create namespace side-projects

export PROJECT_PATH="$( cd "$(dirname "$0")"; cd .. ; pwd -P )";
export HOST_IP=$(echo -n $(ifconfig | grep $( echo $(minikube ip) | sed -e 's/\([0-9]*.[0-9]*.[0-9]*.\)[0-9]*$/\1/' ) | sed -e 's/[[:space:]]*inet[[:space:]]*\([0-9]*.[0-9]*.[0-9]*.[0-9]*.\).*/\1/' ));

export PROJECT_PATH="/Users/sylvestre/development/http-server"

echo "minikube_launch.sh : Ensure that the folder is mounted into minikube"
sh "$PROJECT_PATH/bin/minikube_nsfd_mount.sh"

echo "minikube_launch.sh : Apply the persistant Volume & persistant Volume claims"


# Delete previous pod, services, pv, claim, ingress ...
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/app/ingress.yaml"
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/app/service.yaml"
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/app/deployment.yaml"
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/volumes/tmp.claim.yaml"
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/volumes/tmp.pv.yaml"
kubectl delete -f "$PROJECT_PATH/.kubernetes/minikube/volumes/source.claim.yaml"
envsubst < "$PROJECT_PATH/.kubernetes/minikube/volumes/source.pv.yaml" | kubectl delete -f -

# Recreate pod, services, pv, claim, ingress ...
envsubst < "$PROJECT_PATH/.kubernetes/minikube/volumes/source.pv.yaml" | kubectl apply -f -
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/volumes/source.claim.yaml"
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/volumes/tmp.pv.yaml"
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/volumes/tmp.claim.yaml"
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/app/deployment.yaml"
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/app/service.yaml"
kubectl apply -f "$PROJECT_PATH/.kubernetes/minikube/app/ingress.yaml"
