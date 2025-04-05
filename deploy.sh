#!/bin/bash

#!/bin/bash

# ✅ Vérification que le script est exécuté en tant que root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Ce script doit être exécuté en tant que root. Veuillez utiliser sudo ou passer en mode root."
  exit 1
fi


set -e  # Arrêter le script en cas d'erreur

## 📌 Vérification des dépendances
echo "🔍 Vérification des dépendances..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl n'est pas installé. Veuillez l'installer pour exécuter ce script."
    exit 1
fi

if ! command -v minikube &> /dev/null; then
    echo "❌ minikube n'est pas installé. Veuillez l'installer pour exécuter ce script."
    exit 1
fi

echo "✅ Toutes les dépendances sont présentes."

## 🚀 Démarrage de Minikube si non actif
if ! minikube status | grep -q "host: Running"; then
    echo "⚠️  Minikube n'est pas actif. Lancement du cluster Minikube..."
    minikube start --force
    echo "✅ Minikube démarré avec succès."
else
    echo "✅ Minikube est déjà en cours d'exécution."
fi

echo "---------------------------------------------------------"


echo ""
echo "🚀 Déploiement complet de l'infrastructure Kubernetes..."
echo "========================================================="

## 🔹 Redis (Master + Replicas)
echo "🧠 Déploiement de Redis Master..."
kubectl apply -f k8s/redis/redis-master-deployment.yaml
kubectl apply -f k8s/redis/redis-master-service.yaml

echo "🧠 Déploiement de Redis Replicas..."
kubectl apply -f k8s/redis/redis-replica-deployment.yaml
kubectl apply -f k8s/redis/redis-replica-service.yaml
kubectl apply -f k8s/redis/redis-replica-hpa.yaml

echo "✅ Redis Master & Replicas déployés avec succès !"
echo "---------------------------------------------------------"

## 🔹 Backend Node.js
echo "🧩 Déploiement du backend redis-node..."
kubectl apply -f k8s/redis-node/redis-node-deployment.yaml
kubectl apply -f k8s/redis-node/redis-node-service.yaml
kubectl apply -f k8s/redis-node/redis-node-hpa.yaml

echo "✅ Backend redis-node déployé avec succès !"
echo "---------------------------------------------------------"

## 🔹 Frontend React
echo "🌐 Déploiement du frontend redis-react..."
kubectl apply -f k8s/redis-react/redis-react-deployment.yaml
kubectl apply -f k8s/redis-react/redis-react-service.yaml

echo "✅ Frontend redis-react déployé avec succès !"
echo "---------------------------------------------------------"

## 🔧 Vérification & installation de metrics-server pour HPA
echo "📏 Vérification de la présence de metrics-server..."

if ! kubectl get deployment metrics-server -n kube-system &>/dev/null; then
    echo "⚙️  metrics-server non trouvé. Installation en cours..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

    echo "🔧 Patch de metrics-server pour permettre l'accès insecure TLS..."
    kubectl patch deployment metrics-server -n kube-system \
      --type='json' \
      -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

    echo "⏳ Attente de la disponibilité de metrics-server (10s)..."
    sleep 10
else
    echo "✅ metrics-server est déjà installé."
fi

echo "---------------------------------------------------------"

## 🔹 Prometheus
echo "📈 Déploiement de Prometheus..."
kubectl apply -f k8s/monitoring/prometheus/prometheus-config.yaml
kubectl apply -f k8s/monitoring/prometheus/prometheus-deployment.yaml
kubectl apply -f k8s/monitoring/prometheus/prometheus-service.yaml

echo "✅ Prometheus déployé avec succès !"
echo "---------------------------------------------------------"

## 🔹 Grafana
echo "📊 Déploiement de Grafana..."
kubectl apply -f k8s/monitoring/grafana/grafana-deployment.yaml
kubectl apply -f k8s/monitoring/grafana/grafana-service.yaml

echo "✅ Grafana déployé avec succès !"
echo "---------------------------------------------------------"


echo "🕒 Veuillez patienter pendant le déploiement des pods..."
echo ""

kubectl get pods

echo "---------------------------------------------------------"
echo "🔄 Vérification en cours..."
echo ""

# Fonction de vérification
wait_for_pods_ready() {
  while true; do
    NOT_READY=$(kubectl get pods --no-headers | awk '{print $2}' | grep -v '1/1' || true)
    if [[ -z "$NOT_READY" ]]; then
      break
    fi
    sleep 2
  done
}

# Exécution de l'attente
wait_for_pods_ready

## ✅ Résumé de l'état
echo "------------------------------------------"
echo "📦 Pods déployés :"
kubectl get pods
echo ""
echo "---------------------------------------------------------"
echo "✅ Tous les pods sont en état RUNNING (1/1) !"

echo "🛰️ Services exposés :"
kubectl get services
echo ""

echo "📈 HPA (autoscaling) actifs :"
kubectl get hpa
echo ""

## 🌐 URLs d'accès via Minikube
echo "🌐 Accès aux services via NodePort :"
echo "------------------------------------------"
echo "🖥️ Frontend React   → $(minikube service redis-react --url)"
echo "🧩 Backend Node      → $(minikube service redis-node --url)"
echo "📈 Prometheus        → $(minikube service prometheus --url)"
echo "📊 Grafana           → $(minikube service grafana --url)"
echo ""
echo "ℹ️  Pour vous connecter à Grafana, utilisez :"
echo "   - identifiant : admin"
echo "   - mot de passe : admin"
echo ""

echo "🎉 Déploiement terminé avec succès ! Vous pouvez maintenant accéder aux services depuis votre navigateur."