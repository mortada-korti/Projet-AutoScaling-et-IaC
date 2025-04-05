#!/bin/bash

echo "📊 Simulation de charge sur Redis..."

# Set une clé dans le master
echo "📥 Insertion de la clé dans redis-master..."
kubectl exec deploy/redis-master -- redis-cli set testkey "KORTI-BENKACI"

echo "🛑 Appuyez sur Ctrl+C pour arrêter la simulation."

# Boucle infinie de lecture
kubectl exec -it deploy/redis-replica -- sh -c 'while true; do redis-cli get testkey; done'

echo "✅ Simulation terminée."
