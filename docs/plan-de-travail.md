# Plan de travail — équipe de 2

## Règle d'organisation

Les deux membres doivent contribuer régulièrement au dépôt et intervenir pendant la soutenance. Les tâches ci-dessous sont une proposition à adapter ensemble.

## Répartition proposée

### Membre A — infrastructure et sécurité
- Docker Compose, réseaux et volumes ;
- reverse proxy ;
- Authentik, OIDC, groupes et policies ;
- durcissement de base et documentation des secrets.

### Membre B — application et qualité
- étude du code et de l'image Rallly ;
- tests et développement des fonctionnalités ;
- workflow CI ;
- captures et documentation de démonstration.

### Travail commun
- revue des Pull Requests ;
- diagnostic des problèmes ;
- tests d'intégration ;
- déploiement VM Énov ;
- répétition de la soutenance.

Cette répartition n'empêche pas chaque membre de comprendre l'ensemble de l'architecture.

## Jalons

1. Dépôt et conventions Git prêts.
2. Stack locale démarrable.
3. Proxy fonctionnel.
4. Authentik et SSO OIDC opérationnels.
5. Policies par groupe et invitation externe démontrées.
6. CI verte.
7. Fonctionnalités attribuées développées et testées.
8. Déploiement VM validé.
9. Soutenance répétée.

## Git au quotidien

```bash
git switch -c docs/ma-tache
git status
git add README.md docs/
git commit -m "docs: describe project architecture"
git push -u origin docs/ma-tache
```

Créer ensuite une Pull Request vers `main` et demander une relecture au binôme. Adapter les chemins et le message du commit aux fichiers réellement modifiés.
