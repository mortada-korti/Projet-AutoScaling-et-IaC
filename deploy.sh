#!/bin/bash

set -e  # Stop script if any command fails

echo "🚀 Déploiement complet de l'infrastructure Kubernetes..."
echo "---------------------------------------------"

## 🔹 Redis (Master + Replicas)
echo "🧠 Déploiement de Redis Master..."
kubectl apply -f k8s/redis/redis-master-deployment.yaml
kubectl apply -f k8s/redis/redis-master-service.yaml

echo "🧠 Déploiement de Redis Replicas..."
kubectl apply -f k8s/redis/redis-replica-deployment.yaml
kubectl apply -f k8s/redis/redis-replica-service.yaml
kubectl apply -f k8s/redis/redis-replica-hpa.yaml

echo "✅ Redis Master & Replicas déployés avec succès !"
echo "---------------------------------------------"

## 🔹 Backend Node.js
echo "🧩 Déploiement du backend redis-node..."
kubectl apply -f k8s/redis-node/redis-node-deployment.yaml
kubectl apply -f k8s/redis-node/redis-node-service.yaml
kubectl apply -f k8s/redis-node/redis-node-hpa.yaml

echo "✅ Backend redis-node déployé avec succès !"
echo "---------------------------------------------"

## 🔹 Frontend React
echo "🌐 Déploiement du frontend redis-react..."
kubectl apply -f k8s/redis-react/redis-react-deployment.yaml
kubectl apply -f k8s/redis-react/redis-react-service.yaml

echo "✅ Frontend redis-react déployé avec succès !"
echo "---------------------------------------------"

## 🔹 Prometheus
echo "📈 Déploiement de Prometheus..."
kubectl apply -f k8s/monitoring/prometheus/prometheus-config.yaml
kubectl apply -f k8s/monitoring/prometheus/prometheus-deployment.yaml
kubectl apply -f k8s/monitoring/prometheus/prometheus-service.yaml

echo "✅ Prometheus déployé avec succès !"
echo "---------------------------------------------"

## 🔹 Grafana
echo "📊 Déploiement de Grafana..."
kubectl apply -f k8s/monitoring/grafana/grafana-deployment.yaml
kubectl apply -f k8s/monitoring/grafana/grafana-service.yaml

echo "✅ Grafana déployé avec succès !"
echo "---------------------------------------------"

echo "🎉 Déploiement terminé avec succès !"
