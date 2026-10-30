# Runbook local macOS

Suivre le démarrage du README. Le premier lancement télécharge plusieurs images et applique les migrations ; patienter jusqu'à cinq minutes.

## Diagnostic

- Docker indisponible : lancer Docker Desktop et vérifier `docker info`.
- Port 8080 occupé : identifier le service concurrent. Le port est aussi présent dans les URL applicatives et OIDC : changer uniquement le port publié ne suffit pas.
- 404 Traefik : utiliser le bon nom d'hôte, pas `http://localhost:8080`.
- 502/503 : `docker compose ps` puis journaux du service concerné ; attendre les migrations.
- Authentik initial setup : conserver le slash final et n'utiliser cette URL qu'avant l'initialisation du compte `akadmin`.
- Courriel absent : vérifier Mailpit et les journaux ; SMTP 1025 est interne, UI 8025 derrière proxy.
- Stockage inaccessible : `docker compose exec garage /garage stats -a`, puis journaux Garage.
- OIDC : vérifier la découverte depuis Rallly, la callback exacte et le secret. Ne jamais copier un secret dans une capture.
- Erreur d'architecture Apple Silicon : les images doivent annoncer arm64 ; ne pas forcer amd64 sans raison et documenter toute émulation.

## Sauvegardes avant modification

```bash
mkdir -p backups
chmod 700 backups
(umask 077; docker compose exec -T rallly-db pg_dump -U rallly rallly > backups/rallly.sql)
(umask 077; docker compose exec -T authentik-db pg_dump -U authentik authentik > backups/authentik.sql)
```

Ces exports contiennent des données privées : `backups/` est gitignoré. Sauvegarder aussi `.env` dans un coffre, les volumes Authentik et Garage. Pour Garage, arrêter les écritures avant une copie cohérente des volumes. Une restauration doit être testée sur des volumes séparés avant d'être utilisée en production.

## Version avec les features du fork

Après la configuration OIDC, utiliser `./scripts/compose-custom.sh` à la place
de `docker compose` pour charger les trois fichiers de configuration. Voir
[le guide d’intégration du fork](integration-fork.md) pour le build, les sauvegardes
et le retour à l’image officielle.
