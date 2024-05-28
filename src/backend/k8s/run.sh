#!/bin/bash

kubectl create namespace asky

# Create the PersistentVolume and PersistentVolumeClaim
kubectl apply -f persistent-volumes/postgres-volume.yaml
kubectl apply -f persistent-volume-claims/postgres-volume-claim.yaml

# Create the ConfigMap containing SQL initialization scripts
kubectl apply -f config-maps/postgres-init-db-config-map.yaml
kubectl apply -f config-maps/gateway-config-map.yaml


# Apply the Deployment for PostgreSQL
kubectl apply -f deployments/postgres-deployment.yaml
kubectl apply -f services/postgres-service.yaml

# Monitor the status of the deployment
kubectl get pods -n asky

# Wait for the PostgreSQL pod to be in a running state
echo "Waiting for PostgreSQL pod to be ready..."
kubectl wait --for=condition=Ready pod -l app=postgres -n asky --timeout=300s

# Once the pod is ready, check the logs to ensure initialization was successful
echo "PostgreSQL pod is ready. Checking logs..."
kubectl logs -l app=postgres -n asky

# Apply the Deployment for the backend
kubectl apply -f deployments/auth-deployment.yaml
kubectl apply -f deployments/gateway-deployment.yaml
kubectl apply -f deployments/pyxis-deployment.yaml
kubectl apply -f deployments/request-management-deployment.yaml

# Apply the Service for the backend
kubectl apply -f services/auth-service.yaml
kubectl apply -f services/gateway-service.yaml
kubectl apply -f services/pyxis-service.yaml
kubectl apply -f services/request-management-service.yaml

