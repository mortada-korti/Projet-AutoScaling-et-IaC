#!/bin/bash

echo "🔍 Vérification de l'état de l'infrastructure..."

echo "-------------------------"
echo "📦 Pods déployés :"
kubectl get pods

echo "-------------------------"
echo "🛰️ Services exposés :"
kubectl get services

echo "-------------------------"
echo "📈 HPA (autoscaling) actifs :"
kubectl get hpa

echo "-------------------------"
echo "🌐 URL des services NodePort (via minikube):"
echo "Frontend React  → $(minikube service redis-react --url)"
echo "Backend Node    → $(minikube service redis-node --url)"
echo "Prometheus      → $(minikube service prometheus --url)"
echo "Grafana         → $(minikube service grafana --url)"

echo "✅ Vérification terminée."
