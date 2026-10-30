# Runbook local

La procédure d'installation et les paramètres du `.env` sont décrits dans
[le README](../README.md).

## Vérifications préalables

```bash
docker --version
docker compose version
docker info
```

## Démarrage et diagnostic

```bash
docker compose config --quiet
docker compose up -d --build
docker compose ps
docker compose logs -f authentik_server authentik_worker
```

Rallly est accessible sur <http://localhost:3000> et Authentik sur
<http://authentik.localhost:9000>. Au premier accès, configurer le compte `akadmin`.
Rallly utilise Authentik pour la connexion ; voir [la configuration OIDC](authentik-oidc.md).

## Arrêt

`docker compose down` arrête les services en conservant les volumes PostgreSQL
et les fichiers Authentik. L'option `--volumes` supprime toutes ces données.
