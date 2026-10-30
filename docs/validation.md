# Rapport de validation — 29 octobre 2026

## Contrôles réussis

- Docker Engine 29.8.2 et Docker Compose 5.5.1 accessibles.
- `docker compose config --quiet` : code 0.
- Validation du complément OIDC avec une valeur de test temporaire : code 0 ; absence de secret correctement refusée.
- Syntaxe Bash des trois scripts : code 0.
- Génération de `.env` : permissions 600 ; second lancement refusé et empreinte du fichier inchangée.
- Inspection du modèle Compose résolu : huit services, seul Traefik expose 127.0.0.1:8080, deux réseaux de données internes, aucun montage du socket Docker.
- Téléchargement réussi des six images distinctes. Toutes les images locales sont arm64, sans émulation imposée.
- Image Rallly : utilisateur `nextjs`. Image Authentik : UID 1000. Traefik et Mailpit : UID 65532 imposé dans Compose.
- Lors du premier démarrage, PostgreSQL Authentik a été initialisé et déclaré sain.

## Tests réels réussis

- `docker compose up -d --wait --wait-timeout 300` : code 0. Les sept services avec sonde sont sains ; Traefik est démarré (sans sonde).
- `scripts/smoke-test.sh` : code 0. Rallly HTTP 200, Authentik HTTP 302, Mailpit HTTP 200.
- `pg_isready` : les deux bases acceptent les connexions.
- Garage : bucket `rallly` présent et droits lecture/écriture/propriétaire configurés.
- S3 depuis le conteneur Rallly avec ses identifiants : PUT, GET (contenu vérifié) et DELETE d'un objet temporaire réussis. Aucun objet de test conservé.
- SMTP depuis Authentik : un message de validation accepté sur mailpit:1025 et retrouvé via l'API Mailpit derrière Traefik.
- Résolution de l'alias `authentik.localhost` depuis Rallly vers Traefik, puis HTTP 302 sur l'URL publique Authentik : réussi.
- Le code des versions retenues et les fichiers upstream ont été consultés pour les variables, la callback OIDC et le mode Garage.

Le premier démarrage a temporairement laissé plusieurs conteneurs à l'état Created ; un arrêt ciblé sans suppression des volumes puis une relance ont permis de démarrer. La cause exacte de cette attente Docker n'est pas établie. Aucun redémarrage global de Docker Desktop ni arrêt d'un autre projet n'a été effectué.

La stack reste démarrée dans le dossier du projet. Les secrets sont dans son `.env` local, exclus du ZIP. Mailpit contient un seul message de validation émis par ce test ; il est temporaire et sera perdu à l'arrêt du conteneur.

## Parcours non encore validés

La création d'un sondage dans le navigateur, l'upload via l'UI et la persistance d'un sondage après redémarrage ne sont pas testés. Le test S3 vérifie l'accès technique au stockage, pas le parcours utilisateur d'upload.

Mise à jour du 29 octobre 2026 : le compte administrateur est initialisé et l'application/fournisseur rallly existe. Le parcours SSO navigateur a réussi, du bouton Authentik jusqu'au retour authentifié sur /setup de Rallly. Le profil reste à finaliser par l'utilisateur. Les groupes et l'invitation externe restent à configurer et démontrer ; voir docs/authentik-oidc.md.

## Références des images téléchargées

Les digests observés ci-dessous servent à la traçabilité de ce test (ils ne remplacent pas une validation fonctionnelle). Le Compose conserve les tags lisibles ; postgres:16-alpine peut évoluer.

| Image | Digest observé |
|---|---|
| traefik:v3.6.1 | sha256:fd5932c796f7e2db9fd6bff485ef693d53797f0ee8ad03dc68aa424ea6f21958 |
| lukevella/rallly:4.16.3 | sha256:7837f8148cc6db5e3e9a8df199912950adaee66898ebad4949d9dbb2f30aa02b |
| ghcr.io/goauthentik/server:2026.8.5 | sha256:602227a86455d6772e3d16b7d852713c4f864f40df5df894abd1285bb53979a5 |
| dxflrs/garage:v2.3.0 | sha256:866bd13ed2038ba7e7190e840482bc27234c4afaf77be8cfa439ae088c1e4690 |
| axllent/mailpit:v1.27.10 | sha256:b1f1be18af530d939a11ee8820b379e0c88eeec204d904bfad68862adced3a5a |
| postgres:16-alpine | sha256:0cefaabd882e42bcb2a2f3dc56d3ce4770560ba62fd7f197f1a2e008fd5731ab |

## Contrôles hors périmètre de cette étape

Pas de scan CVE exécuté, pas de pipeline distante lancée, pas de build custom, pas de déploiement VM. Le workflow ajouté valide seulement le modèle Compose et les scripts ; il ne couvre pas encore le build demandé pour le livrable final du module.


## Intégration réelle de l’image du fork — 30 octobre 2026

La construction locale a été abandonnée après des échecs mémoire sur le Mac de
8 Go. L’image finale a été compilée sur GitHub ARM64, depuis le Dockerfile du
fork au commit `413ff340dd2dab415e1779776262ce9a402a71ec` :
https://github.com/Geoffrey-COUTANT/rallly/actions/runs/41049272721 (succès).

Contrôles effectivement réussis :
- archive téléchargée, SHA-256 vérifié puis image importée ;
- architecture `arm64`, utilisateur applicatif `nextjs`, révision vérifiée ;
- remplacement du seul conteneur Rallly par `m2-rallly:413ff340d`, sans build local ;
- conteneur déclaré `healthy` et `/api/status` : production, révision attendue,
  `database=connected` ;
- migration `20261030100000_add_poll_option_capacity` terminée ;
- sauvegarde privée vérifiée avant démarrage dans `backups/` (ignoré) ;
- deux comptes et zéro sondage conservés immédiatement après migration ;
- smoke test proxy/Rallly/Authentik/Mailpit, deux PostgreSQL et Garage : succès ;
- connexion navigateur via Authentik avec `invite-externe-2`, consentement OIDC,
  retour authentifié dans Rallly, profil Personnel finalisé et accueil accessible ;
- vérification du compte Authentik : actif, type `external`, seul groupe
  `rallly-autorises` ; le compte créé dans Rallly par ce SSO est normal et s’ajoute
  aux comptes déjà présents.

Les deux features sont celles du commit déjà validé par la CI du fork ; leurs
1 139 tests unitaires et 19 tests PostgreSQL ont été exécutés précédemment. Une
nouvelle recette manuelle complète des deux features sur 8080 reste à capturer.
Un bandeau de dépassement des limites de licence est visible sur l’accueil de
Rallly ; il n’a pas empêché le SSO et l’accès observés. Aucun contournement de
licence n’est inclus dans cette intégration.

La configuration personnalisée se démarre via `scripts/compose-custom.sh`.
L’artefact de transport GitHub est temporaire (3 jours), mais l’image importée
reste dans Docker. La publication durable en registre, le scan et la VM restent
à compléter. Voir `integration-fork.md` pour l’import et le retour arrière.
