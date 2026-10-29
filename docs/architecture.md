# Architecture cible

## Vue logique

```text
Navigateur
   |
   v
Traefik (point d'entrée HTTP/HTTPS)
   |------------------------|
   v                        v
Authentik                  Rallly
   |                        |
   v                        v
PostgreSQL Authentik       Base de données Rallly
   |
Redis (si requis par la version Authentik retenue)

SMTP de laboratoire : utilisé pour tester les invitations, si nécessaire.
```

Ce schéma est conceptuel. Les services, dépendances et exigences exactes seront ajustés selon les versions officielles retenues.

## Principes

- Un point d'entrée web via le reverse proxy.
- Les bases de données restent sur des réseaux Docker internes et ne sont pas publiées directement.
- Des volumes nommés assurent la persistance.
- Les secrets sont injectés depuis l'environnement et ne sont pas intégrés aux images.
- Le déploiement local et la VM utilisent autant que possible le même Compose et les mêmes images ; les écarts sont documentés.
- Authentik est l'IdP OIDC de Rallly : cette intégration doit être réelle et démontrée, pas simulée.
- Deux groupes au minimum doivent avoir des droits distincts ; le processus d'invitation externe doit être documenté et démontré.

## Environnements

### Local
Docker Compose sur macOS. Les noms de domaine et le TLS local seront décidés à l'étape 2.

### VM Énov
Déploiement après obtention des accès, configuration du VPN NetBird, accès SSH et création de la VM selon la documentation publique du campus. L'URL et les comptes de démonstration seront ajoutés au README une fois validés.

## Flux OIDC à documenter

1. L'utilisateur ouvre Rallly.
2. Rallly redirige vers Authentik pour l'authentification.
3. Authentik authentifie l'utilisateur et applique les règles d'accès prévues.
4. Authentik renvoie le résultat OIDC à l'URI de redirection configurée.
5. Rallly établit la session applicative.

Les URI, scopes, claims et variables doivent correspondre à la documentation des versions utilisées.
