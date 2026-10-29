# Runbook local

Ce document sera complété après l'ajout de `compose.yaml`.

## Vérifications préalables

```bash
docker --version
docker compose version
docker info
```

## Étape actuelle

Le squelette ne lance pas encore de services. Ne lance pas `docker compose up` avant l'étape 2 : le fichier Compose n'a pas encore été créé.

## Quand la stack sera ajoutée

La procédure définitive précisera :
- la création du `.env` ;
- la validation de la configuration avec `docker compose config` ;
- le démarrage ;
- les URLs locales ;
- les commandes de diagnostic ;
- l'arrêt et la conservation des volumes ;
- la réinitialisation des données de test.
