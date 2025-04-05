# 🚀 Projet AutoScaling et IaC avec Kubernetes + Prometheus + Grafana

Bienvenue dans notre projet DevOps de déploiement complet d'une application Node.js avec un frontend React, une base Redis, et un système de monitoring Prometheus + Grafana — le tout orchestré dans un cluster Kubernetes avec Minikube.

---

### 📁 Structure du projet

```
Projet-AutoScaling-et-IaC/
│
├── k8s/                     
├── redis-node/               
├── redis-react/                        
│   ├── redis/
│   ├── redis-node/
│   ├── redis-react/
│   └── monitoring/
│       ├── prometheus/
│       └── grafana/
├── deploy.sh  
├── destroy.sh    
├── stress-backend.sh
├── stress-db.sh             
└── README.md
```

---

### 🧰 Technologies utilisées

- Kubernetes (Minikube)
- Docker
- Node.js + Express
- Redis (Master + Replicas)
- React
- Prometheus
- Grafana

---

### ✅ Prérequis

Avant de lancer le projet, vous devez avoir :

- Docker
- kubectl
- minikube
- Un compte DockerHub (si vous voulez pusher les images)

---

### ▶️ Lancer le projet

```bash
# ✅ Si vous êtes déjà en tant que root :
./deploy.sh

# ✅ Sinon, avec sudo :
sudo ./deploy.sh
```

Ce script :

- Vérifie les dépendances (`kubectl`, `minikube`)
- Démarre automatiquement Minikube si ce n’est pas encore le cas
- Déploie l’application backend, frontend, Redis, Prometheus et Grafana
- Installe et configure automatiquement le **metrics-server** si besoin

---

### 📊 Monitoring & Autoscaling

- **Prometheus** : collecte des métriques de l’API
- **Grafana** : visualisation des métriques (CPU, requêtes, etc.)
- **HPA (Horizontal Pod Autoscaler)** : scaling automatique en fonction de l’utilisation CPU

---

### 🌐 Accès aux services

Après exécution du script `deploy.sh`, les adresses suivantes sont affichées :

- 🖥️ Frontend React → `http://<minikube-ip>:<nodePort>`
- 🧩 Backend Node.js → `http://<minikube-ip>:<nodePort>`
- 📈 Prometheus → `http://<minikube-ip>:<nodePort>`
- 📊 Grafana → `http://<minikube-ip>:<nodePort>`

> **Identifiants Grafana**  
> utilisateur : `admin`  
> mot de passe : `admin`

---

## 🔬 Tests d'auto-scalabilité

Nous avons fourni deux scripts pour tester la montée en charge de manière simple :

- `stress-db.sh` : Simule une lecture massive dans Redis.
- `stress-backend.sh` : Envoie des requêtes HTTP continues vers le backend.

```bash
sudo ./stress-db.sh
sudo ./stress-backend.sh
```

Arrêtez les scripts avec `Ctrl + C`.

---

### 📌 Objectifs du projet

- Mettre en œuvre l’**Infrastructure as Code**
- Déployer une architecture microservices avec **Kubernetes**
- Intégrer un système de **monitoring et de visualisation**
- Implémenter le **scaling automatique** des pods

---

### 🙌 Auteurs

- [Mortada KORTI](https://github.com/mortada-korti)
- [Liza BENKACI](https://github.com/Liza-Benkaci)
---

### 💡 Remarques

- L’ensemble du projet est entièrement **automatisé via `deploy.sh`**
- Le déploiement prend environ 30-60 secondes selon la machine
- Le projet a été testé avec Minikube sous Ubuntu (VM)
