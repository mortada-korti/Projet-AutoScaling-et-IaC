## ✅ Résumé de l'état
echo ""
echo "🧾 Vérification de l'état des composants..."
echo "------------------------------------------"
echo "📦 Pods déployés :"
kubectl get pods
echo ""

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