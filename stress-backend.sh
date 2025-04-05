#!/bin/bash

echo "🌐 Génération de charge sur le backend Node.js..."
echo "📎 URL cible : http://192.168.49.2:30764"

for i in {1..3}; do
  while true; do
    curl -s http://192.168.49.2:30764 >/dev/null
  done &
done

echo "✅ Charge lancée ! Appuyez sur Ctrl+C pour arrêter."
wait

