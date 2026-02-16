# 🚀 Odoo sur Kubernetes avec Talos OS

<div align="center">

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Talos](https://img.shields.io/badge/Talos_OS-FF6C37?style=for-the-badge&logo=linux&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![Odoo](https://img.shields.io/badge/Odoo-714B67?style=for-the-badge&logo=odoo&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)

**Déploiement automatisé d'Odoo ERP sur Kubernetes avec Talos OS et CloudNativePG**

[Documentation](https://graceful-salamander-33c222.netlify.app/guides/odoo-k8s/) • [Installation](#-installation-rapide) • [Architecture](#-architecture) • [Contributing](#-contribution)

</div>

---

## 📋 Table des Matières

- [À Propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Prérequis](#-prérequis)
- [Installation Rapide](#-installation-rapide)
- [Structure du Projet](#-structure-du-projet)
- [Configuration](#️-configuration)
- [Déploiement](#-déploiement)
- [Monitoring](#-monitoring)
- [Maintenance](#-maintenance)
- [Dépannage](#-dépannage)
- [Contribution](#-contribution)
- [Licence](#-licence)

---

## 🎯 À Propos

Ce projet fournit une solution complète et automatisée pour déployer **Odoo ERP** dans un environnement Kubernetes haute disponibilité, utilisant :

- **Talos Linux** : OS immutable et sécurisé conçu pour Kubernetes
- **Proxmox VE** : Plateforme de virtualisation pour l'infrastructure
- **CloudNativePG** : Opérateur PostgreSQL cloud-native pour la persistance
- **Terraform** : Infrastructure as Code pour le provisionnement
- **Ansible** : Automatisation de la configuration
- **GitOps** : Déploiement déclaratif avec FluxCD ou ArgoCD

### Pourquoi ce Stack ?

- ✅ **Immutabilité** : Talos OS garantit une infrastructure prédictible
- ✅ **Sécurité** : Surface d'attaque réduite, pas d'accès SSH
- ✅ **Scalabilité** : Horizontal scaling natif avec Kubernetes
- ✅ **Observabilité** : Monitoring complet avec Prometheus & Grafana
- ✅ **Haute Disponibilité** : Multi-node avec réplication PostgreSQL
- ✅ **GitOps Ready** : Déploiement déclaratif et versionné

---

## ✨ Fonctionnalités

### Infrastructure

- 🏗️ Provisionnement automatique de VMs Talos sur Proxmox
- 🔐 Génération et gestion sécurisée des secrets Talos
- 🌐 Configuration réseau avancée (VLAN, Load Balancer)
- 💾 Gestion du stockage avec CSI (Ceph, NFS, ou local-path)

### Kubernetes

- ⚙️ Cluster Kubernetes HA (3+ control plane nodes)
- 📦 Déploiement Odoo multi-version
- 🗄️ PostgreSQL haute disponibilité avec CloudNativePG
- 🔄 Backup automatique et disaster recovery
- 🚦 Ingress Controller (Traefik ou NGINX)
- 🔒 Gestion des certificats SSL avec cert-manager

### Monitoring & Observabilité

- 📊 Stack Prometheus & Grafana
- 📈 Dashboards préconfigurés pour Odoo et PostgreSQL
- 🔔 Alerting multi-canal (Email, Slack, PagerDuty)
- 📝 Logs centralisés avec Loki
- 🔍 Tracing distribué (optionnel)

---

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Proxmox Cluster                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Talos Linux Control Plane                  │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │   │
│  │  │ Master 1 │  │ Master 2 │  │ Master 3 │              │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘              │   │
│  └───────┼─────────────┼─────────────┼────────────────────┘   │
│          │             │             │                         │
│  ┌───────┴─────────────┴─────────────┴────────────────────┐   │
│  │              Talos Linux Worker Nodes                   │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │   │
│  │  │ Worker 1 │  │ Worker 2 │  │ Worker N │              │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘              │   │
│  └───────┼─────────────┼─────────────┼────────────────────┘   │
└──────────┼─────────────┼─────────────┼────────────────────────┘
           │             │             │
    ┌──────┴─────────────┴─────────────┴──────────┐
    │         Kubernetes Resources                 │
    │  ┌────────────────────────────────────────┐  │
    │  │          Odoo Application              │  │
    │  │  ┌──────────┐      ┌──────────┐       │  │
    │  │  │   Odoo   │◄────►│ CloudPG  │       │  │
    │  │  │  Pods    │      │ Cluster  │       │  │
    │  │  └──────────┘      └──────────┘       │  │
    │  └────────────────────────────────────────┘  │
    │  ┌────────────────────────────────────────┐  │
    │  │       Infrastructure Layer             │  │
    │  │  • Ingress (Traefik/NGINX)            │  │
    │  │  • Cert-Manager                       │  │
    │  │  • Storage CSI                        │  │
    │  │  • Monitoring Stack                   │  │
    │  └────────────────────────────────────────┘  │
    └──────────────────────────────────────────────┘
```

### Flux de Données

```
User Request → Load Balancer → Ingress Controller → Odoo Pod → CloudNativePG
                                                                      ↓
                                                              Persistent Storage
```

---

## 📋 Prérequis

### Infrastructure

- **Proxmox VE** : Version 9.0+ recommandée
- **Ressources minimales** :
  - 3 nodes control plane : 2 vCPU, 4 GB RAM chacun
  - 2+ nodes worker : 4 vCPU, 8 GB RAM chacun
  - 200+ GB de stockage disponible

### Outils Requis

| Outil | Version | Installation |
|-------|---------|-------------|
| `terraform` | ≥ 1.5.0 | [Download](https://www.terraform.io/downloads) |
| `ansible` | ≥ 2.15.0 | `pip install ansible` |
| `kubectl` | ≥ 1.28.0 | [Install Guide](https://kubernetes.io/docs/tasks/tools/) |
| `talosctl` | ≥ 1.6.0 | [Install Guide](https://www.talos.dev/latest/talos-guides/install/talosctl/) |
| `helm` | ≥ 3.12.0 | [Install Guide](https://helm.sh/docs/intro/install/) |

### Connaissances Recommandées

- 🐧 Administration Linux
- ☸️ Concepts Kubernetes (Pods, Services, Ingress, StatefulSets)
- 🗄️ Gestion PostgreSQL
- 🔧 Infrastructure as Code (Terraform/Ansible)

---

## 🚀 Installation Rapide

### 1. Cloner le Repository

```bash
git clone https://github.com/votre-org/odoo-k8s-talos.git
cd odoo-k8s-talos
```

### 2. Configurer les Variables

```bash
# Copier les fichiers d'exemple
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
cp ansible/inventory/hosts.example.yml ansible/inventory/hosts.yml

# Éditer avec vos valeurs
vim terraform/terraform.tfvars
vim ansible/inventory/hosts.yml
```

### 3. Provisionner l'Infrastructure

```bash
cd terraform

# Initialiser Terraform
terraform init

# Valider la configuration
terraform plan

# Déployer l'infrastructure
terraform apply -auto-approve
```

### 4. Bootstrapper Talos Cluster

```bash
# Exécuter le playbook de bootstrap
cd ../ansible
ansible-playbook -i inventory/hosts.yml playbooks/bootstrap-talos.yml

# Vérifier le cluster
export KUBECONFIG=~/.kube/config-talos
kubectl get nodes
```

### 5. Déployer l'Infrastructure Kubernetes

```bash
cd ../kubernetes

# Installer les dépendances
./scripts/deploy-infrastructure.sh

# Vérifier les composants
kubectl get pods -A
```

### 6. Déployer Odoo

```bash
# Déployer l'application
kubectl apply -k apps/odoo-cnpg/overlays/production

# Attendre que les pods soient prêts
kubectl wait --for=condition=ready pod -l app=odoo -n odoo --timeout=300s

# Obtenir l'URL d'accès
kubectl get ingress -n odoo
```

### 7. Accéder à Odoo

```bash
# URL par défaut
https://odoo.votredomaine.com

# Credentials par défaut (À CHANGER IMMÉDIATEMENT)
Email: admin@example.com
Password: admin
```

---

## 📁 Structure du Projet

```
.
├── ansible/                    # Automatisation Ansible
│   ├── inventory/             # Inventaires d'hôtes
│   │   ├── hosts.yml          # Configuration des hôtes
│   │   └── group_vars/        # Variables par groupe
│   ├── playbooks/             # Playbooks Ansible
│   │   ├── bootstrap-talos.yml
│   │   ├── configure-storage.yml
│   │   └── deploy-monitoring.yml
│   └── roles/                 # Rôles réutilisables
│       ├── talos-config/
│       ├── k8s-setup/
│       └── backup-config/
│
├── kubernetes/                # Manifestes Kubernetes
│   ├── apps/                  # Applications
│   │   └── odoo-cnpg/        # Configuration Odoo
│   │       ├── base/         # Ressources de base
│   │       └── overlays/     # Environnements (dev/prod)
│   ├── bootstrap/            # Initialisation cluster
│   │   ├── namespaces.yaml
│   │   └── rbac.yaml
│   ├── gitops/               # Configuration GitOps
│   │   ├── flux/
│   │   └── argocd/
│   └── infrastructure/       # Infrastructure K8s
│       ├── base/
│       │   ├── cert-manager/
│       │   ├── ingress/
│       │   └── storage/
│       ├── monitoring/
│       │   ├── prometheus/
│       │   ├── grafana/
│       │   └── loki/
│       └── networking/
│           ├── metallb/
│           └── cilium/
│
├── scripts/                   # Scripts utilitaires
│   ├── backup.sh             # Backup automatique
│   ├── deploy-infrastructure.sh
│   ├── generate-secrets.sh
│   └── restore.sh            # Restauration
│
├── terraform/                # Provisionnement IaC
│   ├── main.tf               # Configuration principale
│   ├── variables.tf          # Déclaration variables
│   ├── outputs.tf            # Sorties Terraform
│   ├── terraform.tfvars      # Valeurs des variables
│   └── modules/              # Modules réutilisables
│       ├── proxmox-vm/
│       ├── talos-cluster/
│       └── networking/
│
├── docs/                     # Documentation supplémentaire
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT.md
│   ├── MAINTENANCE.md
│   └── TROUBLESHOOTING.md
│
├── .gitignore
├── LICENSE
└── README.md                 # Ce fichier
```

---

## ⚙️ Configuration

### Variables Terraform

Fichier : `terraform/terraform.tfvars`

```hcl
# Configuration Proxmox
proxmox_api_url      = "https://proxmox.example.com:8006/api2/json"
proxmox_api_token_id = "root@pam!terraform"
proxmox_api_token    = "your-secure-token"

# Configuration Cluster
cluster_name         = "odoo-production"
control_plane_count  = 3
worker_count         = 3

# Ressources VMs
control_plane_cpu    = 2
control_plane_memory = 4096
worker_cpu           = 4
worker_memory        = 8192

# Réseau
network_bridge       = "vmbr0"
network_vlan         = 100
ip_range             = "10.0.100.0/24"
gateway              = "10.0.100.1"
```

### Variables Kubernetes

Fichier : `kubernetes/apps/odoo-cnpg/base/kustomization.yaml`

```yaml
configMapGenerator:
  - name: odoo-config
    literals:
      - ODOO_VERSION=17.0
      - WORKERS=4
      - MAX_CRON_THREADS=2
      - LOG_LEVEL=info
      - DB_MAXCONN=100

secretGenerator:
  - name: odoo-secrets
    literals:
      - ADMIN_PASSWORD=changeme
      - DB_PASSWORD=changeme
```

### Configuration CloudNativePG

Fichier : `kubernetes/apps/odoo-cnpg/base/postgresql.yaml`

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: odoo-postgres
spec:
  instances: 3
  storage:
    size: 100Gi
    storageClass: ceph-block
  backup:
    barmanObjectStore:
      destinationPath: s3://backups/odoo-postgres
      s3Credentials:
        secretName: backup-credentials
    retentionPolicy: "30d"
```

---

## 🔧 Déploiement

### Déploiement Complet

```bash
# Déploiement de A à Z
./scripts/full-deploy.sh
```

### Déploiement par Étape

#### 1. Infrastructure Proxmox

```bash
cd terraform
terraform init
terraform apply -var-file=environments/production.tfvars
```

#### 2. Bootstrap Talos

```bash
cd ../ansible
ansible-playbook -i inventory/production playbooks/bootstrap-talos.yml

# Générer kubeconfig
talosctl --talosconfig=./talosconfig kubeconfig
```

#### 3. Infrastructure Kubernetes

```bash
# Installer cert-manager
kubectl apply -f kubernetes/infrastructure/base/cert-manager/

# Installer ingress controller
kubectl apply -f kubernetes/infrastructure/base/ingress/

# Installer le storage CSI
kubectl apply -f kubernetes/infrastructure/base/storage/
```

#### 4. Monitoring

```bash
# Déployer Prometheus & Grafana
kubectl apply -k kubernetes/infrastructure/monitoring/
```

#### 5. Déployer Odoo

```bash
# Créer le namespace
kubectl create namespace odoo

# Déployer PostgreSQL
kubectl apply -f kubernetes/apps/odoo-cnpg/base/postgresql.yaml

# Attendre que PostgreSQL soit prêt
kubectl wait --for=condition=ready cluster/odoo-postgres -n odoo --timeout=300s

# Déployer Odoo
kubectl apply -k kubernetes/apps/odoo-cnpg/overlays/production/
```

### Vérification du Déploiement

```bash
# Vérifier tous les pods
kubectl get pods -A

# Vérifier Odoo spécifiquement
kubectl get pods -n odoo
kubectl logs -n odoo -l app=odoo --tail=100

# Vérifier la base de données
kubectl get cluster -n odoo
kubectl exec -n odoo -it odoo-postgres-1 -- psql -U odoo

# Vérifier l'ingress
kubectl get ingress -n odoo
curl -k https://odoo.votredomaine.com
```

---

## 📊 Monitoring

### Accéder aux Dashboards

```bash
# Port-forward Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80

# Accéder à http://localhost:3000
# Credentials: admin / prom-operator
```

### Dashboards Disponibles

- **Odoo Overview** : Métriques applicatives Odoo
- **PostgreSQL Stats** : Performances base de données
- **Kubernetes Cluster** : État du cluster
- **Node Exporter** : Métriques système
- **Talos Dashboard** : Métriques spécifiques Talos

### Alertes Configurées

- 🔴 Pod Crash Loop
- 🔴 Database Connection Failed
- 🟡 High Memory Usage (>80%)
- 🟡 High CPU Usage (>80%)
- 🟡 Disk Space Low (<20%)
- 🔴 Certificate Expiry (<7 days)

---

## 🛠️ Maintenance

### Backup

#### Backup Automatique

Les backups PostgreSQL sont automatiques via CloudNativePG :

```bash
# Vérifier les backups
kubectl get backup -n odoo

# Forcer un backup manuel
kubectl apply -f - <<EOF
apiVersion: postgresql.cnpg.io/v1
kind: Backup
metadata:
  name: manual-backup-$(date +%Y%m%d-%H%M%S)
  namespace: odoo
spec:
  cluster:
    name: odoo-postgres
EOF
```

#### Backup Manuel Complet

```bash
# Exécuter le script de backup
./scripts/backup.sh --full --output=/backups/odoo-$(date +%Y%m%d)
```

### Restauration

```bash
# Restaurer depuis un backup
./scripts/restore.sh --backup=/backups/odoo-20240115 --target=production
```

### Mise à Jour

#### Mise à Jour Odoo

```bash
# Modifier la version dans kustomization.yaml
cd kubernetes/apps/odoo-cnpg/overlays/production
vim kustomization.yaml  # Changer ODOO_VERSION

# Appliquer la mise à jour
kubectl apply -k .

# Suivre le rollout
kubectl rollout status deployment/odoo -n odoo
```

#### Mise à Jour Kubernetes

```bash
# Mise à jour via Talos
talosctl upgrade --nodes <node-ip> --image ghcr.io/siderolabs/installer:v1.7.0
```

### Scaling

#### Scaling Horizontal Odoo

```bash
# Augmenter le nombre de replicas
kubectl scale deployment odoo -n odoo --replicas=5

# Ou via HPA (Horizontal Pod Autoscaler)
kubectl apply -f - <<EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: odoo-hpa
  namespace: odoo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: odoo
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
EOF
```

#### Scaling PostgreSQL

```bash
# Ajouter un replica PostgreSQL
kubectl patch cluster odoo-postgres -n odoo --type='json' \
  -p='[{"op": "replace", "path": "/spec/instances", "value": 5}]'
```

---

## 🔍 Dépannage

### Problèmes Courants

#### Pods en CrashLoopBackOff

```bash
# Vérifier les logs
kubectl logs -n odoo <pod-name> --previous

# Vérifier les events
kubectl describe pod -n odoo <pod-name>

# Solutions courantes :
# 1. Vérifier les secrets
kubectl get secrets -n odoo
# 2. Vérifier la connexion DB
kubectl exec -n odoo <odoo-pod> -- nc -zv odoo-postgres-rw 5432
```

#### PostgreSQL ne Démarre pas

```bash
# Vérifier le statut du cluster
kubectl get cluster -n odoo odoo-postgres -o yaml

# Vérifier les PVCs
kubectl get pvc -n odoo

# Vérifier les logs de l'opérateur
kubectl logs -n cnpg-system deployment/cnpg-controller-manager
```

#### Ingress non Accessible

```bash
# Vérifier l'ingress
kubectl get ingress -n odoo
kubectl describe ingress -n odoo odoo-ingress

# Vérifier le service
kubectl get svc -n odoo

# Vérifier les certificats
kubectl get certificate -n odoo
```

#### Problèmes de Performance

```bash
# Vérifier les ressources
kubectl top nodes
kubectl top pods -n odoo

# Augmenter les limites si nécessaire
kubectl set resources deployment odoo -n odoo \
  --limits=cpu=2000m,memory=4Gi \
  --requests=cpu=1000m,memory=2Gi
```

### Commandes de Diagnostic

```bash
# État complet du cluster
kubectl get all -A

# Vérifier la santé Talos
talosctl health --nodes <node-ip>

# Vérifier les logs système
talosctl logs -n <node-ip> kubelet

# Vérifier l'utilisation réseau
kubectl get networkpolicies -A

# Dump de toute la configuration
kubectl get all,cm,secret,pvc,ingress -n odoo -o yaml > odoo-dump.yaml
```

### Logs Utiles

```bash
# Logs Odoo en temps réel
kubectl logs -n odoo -l app=odoo -f --tail=100

# Logs PostgreSQL
kubectl logs -n odoo odoo-postgres-1 -c postgres

# Logs Ingress Controller
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

### Processus

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### Guidelines

- 📝 Documenter toute nouvelle fonctionnalité
- ✅ Tester localement avant de soumettre
- 🎨 Suivre les conventions de code existantes
- 📊 Ajouter des tests si applicable
- 🔒 Ne jamais commiter de secrets ou credentials

### Code de Conduite

Nous suivons le [Contributor Covenant](https://www.contributor-covenant.org/). Soyez respectueux et inclusif.

---

## 📚 Ressources

### Documentation Officielle

- [Talos Linux Documentation](https://www.talos.dev/latest/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Odoo Documentation](https://www.odoo.com/documentation/)
- [CloudNativePG Documentation](https://cloudnative-pg.io/)
- [Proxmox VE Documentation](https://pve.proxmox.com/wiki/Main_Page)
- [Documentation with Astro-Starlight](https://graceful-salamander-33c222.netlify.app/)

### Articles et Tutoriels

- [Deploying Talos on Proxmox](https://www.talos.dev/latest/talos-guides/install/virtualized-platforms/proxmox/)
- [Kubernetes Production Best Practices](https://kubernetes.io/docs/setup/best-practices/)
- [PostgreSQL High Availability](https://wiki.postgresql.org/wiki/Replication,_Clustering,_and_Connection_Pooling)

### Support

- 💬 [Discussions GitHub](https://github.com/votre-org/odoo-k8s-talos/discussions)
- 🐛 [Issues GitHub](https://github.com/votre-org/odoo-k8s-talos/issues)


---


## 🙏 Remerciements

- **Talos Team** pour cet excellent OS immutable
- **CloudNativePG Team** pour l'opérateur PostgreSQL
- **Odoo Community** pour l'ERP open-source
- **Kubernetes Community** pour l'orchestration
- **Tous les contributeurs** qui améliorent ce projet

---

## 🗺️ Roadmap

### Version 1.0 (Actuelle)
- ✅ Déploiement de base Odoo + PostgreSQL
- ✅ Monitoring avec Prometheus & Grafana
- ✅ Backup automatique
- ✅ Haute disponibilité

### Version 1.1 (Q2 2024)
- 🔄 Support multi-tenant Odoo
- 🔄 Autoscaling avancé
- 🔄 GitOps avec FluxCD/ArgoCD
- 🔄 Disaster Recovery automatisé

### Version 2.0 (Q3 2024)
- 📋 Support Odoo Enterprise
- 📋 Multi-region deployment
- 📋 Service Mesh (Istio/Linkerd)
- 📋 Chaos Engineering

### Version 3.0 (Q4 2024)
- 📋 IA/ML pour l'optimisation
- 📋 Zero-downtime migrations
- 📋 Advanced security hardening

---

<div align="center">

**⭐ Si ce projet vous aide, n'hésitez pas à mettre une étoile ! ⭐**

Made with ❤️ by [Votre Organisation](https://github.com/votre-org)

[🔝 Retour en haut](#-odoo-sur-kubernetes-avec-talos-os)

</div>

