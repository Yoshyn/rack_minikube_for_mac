#!/bin/bash

kubectl delete -f .kubernetes/development/app.ingress.yaml
kubectl delete -f .kubernetes/development/app.service.yaml
kubectl delete -f .kubernetes/development/app.deployment.yaml
kubectl delete -f .kubernetes/development/tmp.pv-claim.yaml
kubectl delete -f .kubernetes/development/tmp.pv.yaml

kubectl create -f .kubernetes/development/tmp.pv.yaml
kubectl create -f .kubernetes/development/tmp.pv-claim.yaml
kubectl create -f .kubernetes/development/app.ingress.yaml
kubectl create -f .kubernetes/development/app.service.yaml
kubectl create -f .kubernetes/development/app.deployment.yaml
