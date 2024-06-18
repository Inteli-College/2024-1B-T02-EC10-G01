#!/bin/bash

# Create the PersistentVolume and PersistentVolumeClaim
kubectl apply -f persistent_volumes_and_claims.yaml

# Create the ConfigMap containing SQL initialization scripts
kubectl apply -f config_maps.yaml

# Apply the Deployment for PostgreSQL
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml

# Monitor the status of the deployment
kubectl get pods 

# Wait for the PostgreSQL pod to be in a running state
echo "Waiting for PostgreSQL pod to be ready..."
kubectl wait --for=condition=Ready pod -l app=postgres --timeout=300s

# Once the pod is ready, check the logs to ensure initialization was successful
echo "PostgreSQL pod is ready. Checking logs..."
kubectl logs -l app=postgres 

kubectl apply -f firebase-secret.yaml

# Apply the Deployment for the backend
kubectl apply -f deployments.yaml

# Apply the Service for the backend
kubectl apply -f services.yaml

kubectl apply -f ingress.yaml

# Monitor the status of the deployment
kubectl apply -f logs/elasticsearch-deployment.yaml
kubectl apply -f logs/elasticsearch-service.yaml

kubectl apply -f logs/kibana-deployment.yaml
kubectl apply -f logs/kibana-service.yaml

kubectl apply -f logs/filebeat-claim0-persistentvolumeclaim.yaml
kubectl apply -f logs/filebeat-deployment.yaml

kubectl port-forward svc/kibana 5601:5601


