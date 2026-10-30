# Projet M2 — Dev avec Docker

Stack locale macOS : Traefik, Rallly (image officielle 4.16.3 pour l’initialisation ou image du fork pour les features), Authentik 2026.8.5, deux PostgreSQL 16, Garage et Mailpit. Le dépôt de l'étape 1 est conservé et complété. Voir [rapport des vérifications](docs/validation.md) pour distinguer les tests réalisés des actions restantes.

## Version du fork avec les deux features

La stack principale peut maintenant utiliser le fork du groupe au commit
`413ff340d` : quota par créneau et blocage des votes passés.
Une fois Authentik/OIDC configuré, utiliser systématiquement :

```bash
./scripts/fetch-custom-image.sh 41049272721
./scripts/compose-custom.sh up -d --wait --wait-timeout 300
./scripts/compose-custom.sh ps
```

Rallly reste accessible sur http://rallly.localhost:8080 avec Authentik.
Le [guide d’intégration](docs/integration-fork.md) détaille la construction distante,
la sauvegarde, les migrations, la recette et le retour à l’image officielle.
Les commandes sans surcharge ci-dessous servent à l’initialisation de la stack
avec l’image officielle, avant de configurer OIDC.

## Démarrer sur Mac

Docker Desktop doit être démarré. Allouer environ 6 Go de RAM à Docker est conseillé pour cette stack de laboratoire. Docker Compose v2 récent (ou v5) est requis.

Depuis le dossier du projet :

```bash
./scripts/generate-secrets.sh
./scripts/validate.sh
docker compose pull
docker compose up -d --wait --wait-timeout 300
./scripts/smoke-test.sh
```

Le générateur refuse d'écraser un `.env` existant. Si tu avais créé un `.env` avec le squelette de l'étape 1, conserve une copie privée et adapte ses variables au nouveau `.env.example`. Ne change pas les mots de passe d'une base déjà initialisée sans migration.

Ajouter cette ligne dans `/etc/hosts` avec `sudo nano /etc/hosts` si les noms ne sont pas résolus automatiquement sur ton Mac :

```text
127.0.0.1 rallly.localhost authentik.localhost mailpit.localhost
```

- Rallly : http://rallly.localhost:8080
- Authentik : http://authentik.localhost:8080
- Première configuration Authentik : http://authentik.localhost:8080/if/flow/initial-setup/
- Courriels de test : http://mailpit.localhost:8080

Seul le proxy publie un port, lié à la boucle locale. Aucun SMTP de test n'est envoyé sur Internet. Les courriels reçus par Mailpit sont visibles par toute personne ayant accès au Mac.

## Ce que livre l'étape 2

- Compose exécutable, proxy à configuration statique sans socket Docker ;
- bases séparées, volumes persistants, réseaux de données internes ;
- stockage S3 Garage initialisé par son mode single-node ;
- SMTP de laboratoire Mailpit et génération de secrets ;
- guide de démarrage, recette, dépannage et configuration OIDC ;
- validation Compose et build applicatif dans GitHub Actions.

Le démarrage de base n'active pas OIDC : cela permet d'initialiser Authentik avant de créer son fournisseur. Pour le SSO, suivre [le guide OIDC](docs/authentik-oidc.md), puis ajouter `-f compose.yaml -f compose.oidc.yaml` à toutes les commandes Compose. L'activation OIDC seule ne supprime pas les autres moyens de connexion ni le vote invité.

## Commandes utiles

```bash
docker compose ps
docker compose logs --tail=100 rallly authentik-server authentik-worker
docker compose stop
docker compose start
docker compose down
```

`down` conserve les volumes. `down -v` supprime définitivement les données : ne pas l'utiliser pour un simple redémarrage. Pour mettre à jour, sauvegarder d'abord les bases et volumes et lire les notes de version.

## Suite du projet

1. Refaire la recette SSO/groupes dans la stack intégrée et terminer l’invitation externe.
2. Développer la feature libre et capturer la démo des trois fonctionnalités.
3. Publier les changements d’infrastructure, obtenir la CI verte et compléter scan/publication de l’image.
4. Déployer sur VM Énov avec DNS public/VPN, TLS et secrets distincts.

Les deux features catalogue sont fusionnées et la CI du fork est verte. L’intégration Docker est décrite plus haut ; la feature libre, l’invitation externe, la VM et les preuves finales restent à compléter. Répartition en duo dans [plan-de-travail](docs/plan-de-travail.md).
