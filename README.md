# Projet Annuel - 5ème SRC Lille - Do-cloud.fr - Hébergement d'outils collaboratifs

Présentation oral : 17/07/2024

# Répartition des services / Technologies

![Technno](https://acenox.fr/projet/esgi/Techno.png)

# Architecture matérielle

![Technno](https://acenox.fr/projet/esgi/Archi.png)

# Déployer l'infrastructure

### Etape 1 : Cloner le répertoire

- Télécharger le repository Github pour récupérer les trois fichiers : nextcloud.yml, rds.yaml, vpc.yaml

### Etape 2 : Créer un bucket S3

- Se rendre sur https://us-east-1.console.aws.amazon.com/s3/bucket/create?region=us-east-1
- Upload les fichiers du repository Github
- Récupérer l'object URL du fichier "nextcloud.yml"

![S3](https://acenox.fr/projet/esgi/s3.png)

### Etape 3 : Déployer l'infrastructure

- Se rendre sur https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create
- Sélectionner "Choose an existing template"
- Indiquer l'URL de votre Object URL "nextcloud.yml"

![S3 url](https://acenox.fr/projet/esgi/s3url.png)

### Etape 4 : Configurer les paramètres

- Renseigner les paramètres nécessaires pour déployer votre architecture

/!\ Si vous souhaitez bénéficer d'un DNS, vous devez l'acheter auprès de AWS sur le service "AWS Route53" /!\

### Etape 5 : Attendre

Le déploiement de l'infrastructure prend jusqu'à 30 minutes pour être déployé.

![Cloudformation url](https://acenox.fr/projet/esgi/cloudfini.png)

### Etape 6 : Infos complémentaires

Si vous avez besoin de trouver les infos par rapport à votre Cloudwatch

- Se rendre sur notre stack CloudFormation déployé
- Se rendre dans l'onglet "output"
- Retrouver les différentes URL dont nous pourrions avoir besoin

![CloudWatch](https://acenox.fr/projet/esgi/cloudwatch.png)
