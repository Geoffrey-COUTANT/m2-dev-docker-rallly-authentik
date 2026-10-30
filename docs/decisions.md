# Décisions techniques — étape 2

- Traefik conservé du squelette, provider fichier à la place d'une découverte via socket Docker.
- Local HTTP sur boucle locale uniquement, port unique 8080. TLS sera traité pour la VM.
- Rallly 4.16.3, Authentik 2026.8.5 et Garage 2.3.0 : versions explicites. PostgreSQL suit le tag 16-alpine (mises à jour de correctifs possibles) ; les digests observés sont consignés si le téléchargement réussit.
- Deux bases indépendantes. Pas de Redis Authentik : le Compose officiel 2026.8.5 n'en contient plus.
- Garage suit le mode single-node/default-bucket de la stack officielle Rallly. Pas de CLI S3 d'initialisation supplémentaire.
- Les variables sont transmises service par service : pas de chargement de tout .env dans chaque conteneur.
- Initialisation du compte Authentik manuelle : aucun mot de passe administrateur prédéfini.
- OIDC séparé dans compose.oidc.yaml pour éviter un provider incomplet au premier lancement.
- Pas de build custom, déploiement distant ou feature inventée à cette étape.

## Sources vérifiées le 29 octobre 2026

- https://docs.goauthentik.io/install-config/install/docker-compose/
- https://docs.goauthentik.io/compose.yml
- https://github.com/lukevella/rallly-selfhosted
- https://raw.githubusercontent.com/lukevella/rallly-selfhosted/main/config/garage.toml
- https://github.com/lukevella/rallly/blob/v4.16.3/apps/web/src/env.ts
- https://github.com/lukevella/rallly/blob/v4.16.3/apps/web/src/lib/auth.ts
- https://github.com/lukevella/rallly/blob/v4.16.3/apps/web/Dockerfile

Le sujet pédagogique récupéré depuis la conversation demande aussi VM, policies, invitation, CI/CD et features : ces exigences restent au plan de travail et ne sont pas assimilées à une validation de l'étape locale.
