# Projet Annuel - 5ème SRC Lille - Do-cloud.fr - Hébergement d'outils collaboratifs

Dossier avec des scripts utilitaires pour notre projet

# Suppression de VPC bugué

Nous avons remarqué que dans certains cas nous pouvions avoir des problèmes avec la suppression des VPC, pour corriger
le problème, nous avons crée un petit script pour supprimer les VPC de force.

```
./vpc.sh <id>
```

# Déploiement - Script Deploy CloudFormation

Nous avons crée un script permettant de déployer notre Cloudformation depuis un script bash utile pour pouvoir le déployer
depuis une application web par exemple.

```
./deploy.sh PROJET="staging" ZONE53="" DOMAIN="staging.do-cloud.fr" DB_USER="nextcloud" DB_MIN_CAPACITY=2 DB_MAX_CAPACITY=8 NEXTCLOUD_ADMIN_USER="admin" NEXTCLOUD_DB_NAME="nextcloud" NEXTCLOUD_VERSION="29.0.3" PRIVACY="Private" ECS_PROVIDER="FARGATE" ECS_TASK_CPU=2048 ECS_TASK_MEM=4096 ECS_MIN_CAPACITY=1 ECS_INITIAL_DESIRED_CAPACITY=1 ECS_MAX_CAPACITY=2 ECS_TARGET_CPU_UTILIZATION=50 REDIS_SIZE="cache.t3.small" TEMPLATE_URL="https://nextcloud-esgi-files.s3.amazonaws.com/nextcloud.yml"
```

Liste des paramètres :

- ZONE53=""
- DOMAIN="staging.do-cloud.fr"
- DB_USER="nextcloud"
- DB_MIN_CAPACITY=2
- DB_MAX_CAPACITY=8
- NEXTCLOUD_ADMIN_USER="admin"
- NEXTCLOUD_DB_NAME="nextcloud"
- NEXTCLOUD_VERSION="29.0.3"
- PRIVACY="Private"
- ECS_PROVIDER="FARGATE"
- ECS_TASK_CPU=2048
- ECS_TASK_MEM=4096
- ECS_MIN_CAPACITY=1
- ECS_INITIAL_DESIRED_CAPACITY=1
- ECS_MAX_CAPACITY=2
- ECS_TARGET_CPU_UTILIZATION=50
- REDIS_SIZE="cache.t3.small"
- TEMPLATE_URL="https://nextcloud-esgi-files.s3.amazonaws.com/nextcloud.yml"