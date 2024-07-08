#!/bin/bash

usage() {
  echo "Usage: $0 PROJET=<valeur> ZONE53=<valeur> DOMAIN=<valeur> DB_USER=<valeur> DB_MIN_CAPACITY=<valeur> DB_MAX_CAPACITY=<valeur> NEXTCLOUD_ADMIN_USER=<valeur> NEXTCLOUD_DB_NAME=<valeur> NEXTCLOUD_VERSION=<valeur> PRIVACY=<valeur> ECS_PROVIDER=<valeur> ECS_TASK_CPU=<valeur> ECS_TASK_MEM=<valeur> ECS_MIN_CAPACITY=<valeur> ECS_INITIAL_DESIRED_CAPACITY=<valeur> ECS_MAX_CAPACITY=<valeur> ECS_TARGET_CPU_UTILIZATION=<valeur> REDIS_SIZE=<valeur> TEMPLATE_URL=<valeur>"
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    PROJET=*) PROJET="${1#*=}" ;;
    ZONE53=*) ZONE53="${1#*=}" ;;
    DOMAIN=*) DOMAIN="${1#*=}" ;;
    DB_USER=*) DB_USER="${1#*=}" ;;
    DB_MIN_CAPACITY=*) DB_MIN_CAPACITY="${1#*=}" ;;
    DB_MAX_CAPACITY=*) DB_MAX_CAPACITY="${1#*=}" ;;
    NEXTCLOUD_ADMIN_USER=*) NEXTCLOUD_ADMIN_USER="${1#*=}" ;;
    NEXTCLOUD_DB_NAME=*) NEXTCLOUD_DB_NAME="${1#*=}" ;;
    NEXTCLOUD_VERSION=*) NEXTCLOUD_VERSION="${1#*=}" ;;
    PRIVACY=*) PRIVACY="${1#*=}" ;;
    ECS_PROVIDER=*) ECS_PROVIDER="${1#*=}" ;;
    ECS_TASK_CPU=*) ECS_TASK_CPU="${1#*=}" ;;
    ECS_TASK_MEM=*) ECS_TASK_MEM="${1#*=}" ;;
    ECS_MIN_CAPACITY=*) ECS_MIN_CAPACITY="${1#*=}" ;;
    ECS_INITIAL_DESIRED_CAPACITY=*) ECS_INITIAL_DESIRED_CAPACITY="${1#*=}" ;;
    ECS_MAX_CAPACITY=*) ECS_MAX_CAPACITY="${1#*=}" ;;
    ECS_TARGET_CPU_UTILIZATION=*) ECS_TARGET_CPU_UTILIZATION="${1#*=}" ;;
    REDIS_SIZE=*) REDIS_SIZE="${1#*=}" ;;
    TEMPLATE_URL=*) TEMPLATE_URL="${1#*=}" ;;
    DB_PASSWORD=*|NEXTCLOUD_ADMIN_PASSWORD=*)
      echo "Impossible de definir le mot de passe"
      usage
      ;;
    *)
      echo "ERREUR: $1"
      usage
      ;;
  esac
  shift
done

if [ -z "$PROJET" ] || [ -z "$ZONE53" ] || [ -z "$DOMAIN" ] || [ -z "$DB_USER" ] || [ -z "$DB_MIN_CAPACITY" ] || [ -z "$DB_MAX_CAPACITY" ] || [ -z "$NEXTCLOUD_ADMIN_USER" ] || [ -z "$NEXTCLOUD_DB_NAME" ] || [ -z "$NEXTCLOUD_VERSION" ] || [ -z "$PRIVACY" ] || [ -z "$ECS_PROVIDER" ] || [ -z "$ECS_TASK_CPU" ] || [ -z "$ECS_TASK_MEM" ] || [ -z "$ECS_MIN_CAPACITY" ] || [ -z "$ECS_INITIAL_DESIRED_CAPACITY" ] || [ -z "$ECS_MAX_CAPACITY" ] || [ -z "$ECS_TARGET_CPU_UTILIZATION" ] || [ -z "$REDIS_SIZE" ] || [ -z "$TEMPLATE_URL" ]; then
  usage
fi

generate_password() {
  local PASSWORD_LENGTH=16
  tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c $PASSWORD_LENGTH
}

DB_PASSWORD=$(generate_password)
NEXTCLOUD_ADMIN_PASSWORD=$(generate_password)

echo "Mot de passe du compte admin: $NEXTCLOUD_ADMIN_PASSWORD"

cat > cloudformation.json <<EOL
[
  {
    "ParameterKey": "Projet",
    "ParameterValue": "$PROJET"
  },
  {
    "ParameterKey": "Zone53",
    "ParameterValue": "$ZONE53"
  },
  {
    "ParameterKey": "Domain",
    "ParameterValue": "$DOMAIN"
  },
  {
    "ParameterKey": "DBUser",
    "ParameterValue": "$DB_USER"
  },
  {
    "ParameterKey": "DBPassword",
    "ParameterValue": "$DB_PASSWORD"
  },
  {
    "ParameterKey": "DBMinCapacity",
    "ParameterValue": "$DB_MIN_CAPACITY"
  },
  {
    "ParameterKey": "DBMaxCapacity",
    "ParameterValue": "$DB_MAX_CAPACITY"
  },
  {
    "ParameterKey": "NextCloudAdminUser",
    "ParameterValue": "$NEXTCLOUD_ADMIN_USER"
  },
  {
    "ParameterKey": "NextCloudAdminPassword",
    "ParameterValue": "$NEXTCLOUD_ADMIN_PASSWORD"
  },
  {
    "ParameterKey": "NextCloudDBName",
    "ParameterValue": "$NEXTCLOUD_DB_NAME"
  },
  {
    "ParameterKey": "NextCloudVersion",
    "ParameterValue": "$NEXTCLOUD_VERSION"
  },
  {
    "ParameterKey": "Privacy",
    "ParameterValue": "$PRIVACY"
  },
  {
    "ParameterKey": "EcsProvider",
    "ParameterValue": "$ECS_PROVIDER"
  },
  {
    "ParameterKey": "EcsTaskCpu",
    "ParameterValue": "$ECS_TASK_CPU"
  },
  {
    "ParameterKey": "EcsTaskMem",
    "ParameterValue": "$ECS_TASK_MEM"
  },
  {
    "ParameterKey": "EcsMinCapacity",
    "ParameterValue": "$ECS_MIN_CAPACITY"
  },
  {
    "ParameterKey": "EcsInitialDesiredCapacity",
    "ParameterValue": "$ECS_INITIAL_DESIRED_CAPACITY"
  },
  {
    "ParameterKey": "EcsMaxCapacity",
    "ParameterValue": "$ECS_MAX_CAPACITY"
  },
  {
    "ParameterKey": "EcsTargetCpuUtilization",
    "ParameterValue": "$ECS_TARGET_CPU_UTILIZATION"
  },
  {
    "ParameterKey": "RedisSize",
    "ParameterValue": "$REDIS_SIZE"
  }
]
EOL

aws cloudformation create-stack --stack-name $PROJET --template-url $TEMPLATE_URL --parameters file://cloudformation.json --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND

echo "En attente de la création du stack..."
aws cloudformation wait stack-create-complete --stack-name $PROJET

aws cloudformation describe-stacks --stack-name $PROJET