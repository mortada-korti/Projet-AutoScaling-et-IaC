#!/bin/bash

set -e  # Stop on error

echo "🧨 Suppression complète de l'infrastructure Kubernetes..."
echo "---------------------------------------------"

## 🔹 Grafana
echo "🧹 Suppression de Grafana..."
kubectl delete -f k8s/monitoring/grafana/grafana-service.yaml || true
kubectl delete -f k8s/monitoring/grafana/grafana-deployment.yaml || true

## 🔹 Prometheus
echo "🧹 Suppression de Prometheus..."
kubectl delete -f k8s/monitoring/prometheus/prometheus-service.yaml || true
kubectl delete -f k8s/monitoring/prometheus/prometheus-deployment.yaml || true
kubectl delete -f k8s/monitoring/prometheus/prometheus-config.yaml || true

## 🔹 Frontend
echo "🧹 Suppression du frontend redis-react..."
kubectl delete -f k8s/redis-react/redis-react-service.yaml || true
kubectl delete -f k8s/redis-react/redis-react-deployment.yaml || true

## 🔹 Backend
echo "🧹 Suppression du backend redis-node..."
kubectl delete -f k8s/redis-node/redis-node-hpa.yaml || true
kubectl delete -f k8s/redis-node/redis-node-service.yaml || true
kubectl delete -f k8s/redis-node/redis-node-deployment.yaml || true

## 🔹 Redis
echo "🧹 Suppression des Redis Replicas..."
kubectl delete -f k8s/redis/redis-replica-hpa.yaml || true
kubectl delete -f k8s/redis/redis-replica-service.yaml || true
kubectl delete -f k8s/redis/redis-replica-deployment.yaml || true

echo "🧹 Suppression de Redis Master..."
kubectl delete -f k8s/redis/redis-master-service.yaml || true
kubectl delete -f k8s/redis/redis-master-deployment.yaml || true

echo "✅ Suppression terminée avec succès."
