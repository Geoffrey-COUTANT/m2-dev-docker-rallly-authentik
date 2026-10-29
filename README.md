# Projet M2 — Dev avec Docker

> Année 2026–2027 · M2 DEVFULLSTACK · Groupe de 2  
> Sujet de référence : « Sujet de projet — Dev avec Docker »

## Objectif

Construire un environnement reproductible, d'abord en local puis sur une VM Énov, autour de :

- Docker Compose ;
- un reverse proxy (choix provisoire : Traefik) ;
- Authentik configuré comme fournisseur d'identité OIDC ;
- Rallly self-hosted ;
- une pipeline CI/CD ;
- deux fonctionnalités du catalogue attribuées par le formateur et une fonctionnalité libre.

**Priorité : stabiliser l'infrastructure avant de développer les fonctionnalités Rallly.** Les choix de versions et les variables exactes seront validés avant la création du Compose définitif.

## État du dépôt

Ce dépôt est le **squelette de départ**. Il ne contient pas encore la stack complète et ne doit pas être présenté comme déployé ou opérationnel.

- [ ] Confirmer avec le formateur les deux fonctionnalités attribuées.
- [ ] Vérifier les versions et documentations officielles de Rallly et Authentik.
- [ ] Construire et tester la stack locale.
- [ ] Démontrer le SSO OIDC, les policies par groupe et l'invitation externe.
- [ ] Ajouter les fonctionnalités retenues.
- [ ] Valider la CI sur la branche principale.
- [ ] Déployer sur la VM Énov et documenter les écarts.
- [ ] Préparer la soutenance.

## Prérequis

- macOS ;
- Docker Desktop installé et démarré ;
- Git ;
- un compte GitHub ;
- accès à la documentation et, plus tard, à la VM Énov.

Vérifier les outils :

```bash
docker --version
docker compose version
git --version
docker info
```

`docker info` doit répondre sans erreur. Si Docker Desktop est fermé, lance-le avant de continuer.

## Arborescence

```text
.
├── .env.example
├── .gitignore
├── README.md
├── SECURITY.md
├── docker/
│   ├── authentik/
│   ├── rallly/
│   └── traefik/
├── docs/
│   ├── architecture.md
│   ├── decisions.md
│   ├── plan-de-travail.md
│   ├── runbook-local.md
│   ├── runbook-enov.md
│   ├── authentik-oidc.md
│   ├── features.md
│   └── soutenance.md
├── scripts/
└── .github/
    └── workflows/
        └── ci.yml
```

## Secrets et configuration

1. Copier `.env.example` vers `.env` uniquement lorsque les variables nécessaires à la stack auront été confirmées.
2. Remplacer tous les exemples par des valeurs locales fortes.
3. Ne jamais committer `.env`, mots de passe, jetons, clés privées ou fichiers de certificats.
4. Pour la VM, utiliser une configuration distincte et sécurisée ; ne pas recopier les secrets de production dans GitHub.
5. Les secrets du workflow GitHub devront être ajoutés dans les paramètres du dépôt uniquement si un déploiement automatisé est retenu.

Le fichier `.env.example` est un inventaire initial de paramètres envisagés, pas encore une configuration exécutable. Il sera ajusté à la version précise des images retenues.

## Développement en équipe

- Créer des branches courtes par tâche : `docs/...`, `infra/...`, `feature/...`.
- Ouvrir une Pull Request pour les changements importants.
- Faire relire les changements de l'autre membre.
- Ne jamais partager les secrets dans les issues, commits ou captures d'écran.
- Garder des commits réguliers et explicites.

## Démarrage

À cette première étape, on prépare le dépôt et sa documentation. **Il n'y a pas encore de `compose.yaml` fonctionnel** : il sera ajouté à l'étape 2, après vérification des images et de leurs configurations officielles.

Voir :
- [Architecture](docs/architecture.md)
- [Plan de travail](docs/plan-de-travail.md)
- [Décisions techniques](docs/decisions.md)
- [Sécurité](SECURITY.md)
