# Décisions techniques (journal)

Les choix ci-dessous sont provisoires tant que la stack n'a pas été construite et testée.

| Sujet | Choix provisoire | Pourquoi / validation requise |
|---|---|---|
| Orchestration | Docker Compose | Demandé pour une stack locale reproductible |
| Reverse proxy | Traefik | Routage Docker et configuration déclarative ; confirmer les besoins TLS |
| Fournisseur d'identité | Authentik | Imposé par le sujet |
| Application | Rallly self-hosted et fork si nécessaire | Imposé par le sujet |
| CI | GitHub Actions | Recommandé dans le sujet |
| Développement | macOS + Docker Desktop | Environnement de l'équipe |
| Déploiement | VM Énov | Imposé par le sujet |

## Points à confirmer avant de figer la configuration

- Versions stables et compatibilités de Rallly, Authentik, PostgreSQL et Redis.
- Variables d'environnement réellement supportées par les images choisies.
- Méthode officielle de déploiement self-hosted Rallly.
- URI OIDC, scopes et claims nécessaires.
- DNS, TLS et contraintes réseau de la VM Énov.
- Fonctionnalités du catalogue attribuées par le formateur.
