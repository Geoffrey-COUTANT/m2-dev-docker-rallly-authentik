# Image du fork intégrée à la stack

## Source et contenu

Fork : https://github.com/Geoffrey-COUTANT/rallly

Commit applicatif : `413ff340dd2dab415e1779776262ce9a402a71ec` (main, PR #1 et #2 fusionnées).
Image : `m2-rallly:413ff340d`, plateforme `linux/arm64`, utilisateur `nextjs`.
Le Dockerfile est celui du fork : `apps/web/Dockerfile`.

Fonctionnalités : quota de participants par créneau et blocage des votes sur les
créneaux passés. Les bases et les comptes de la démo 3025 restent séparés.

## Construction distante et import local

Pour éviter de saturer ce Mac de 8 Go, la compilation se fait sur un runner
GitHub ARM64. Aucun secret du projet n'est envoyé au build. Le workflow ne peut
que lire le code et produire un artefact temporaire : pas de publication sur
Docker Hub, pas de secret de registre à fournir.

Exécution : https://github.com/Geoffrey-COUTANT/rallly/actions/runs/41049272721
Workflow : `.github/workflows/project-image.yml`, branche `codex/build-project-image` du fork.

Avec GitHub CLI authentifié sur le dépôt et Docker Desktop démarré :

```bash
./scripts/fetch-custom-image.sh 41049272721
./scripts/compose-custom.sh up -d --no-deps --wait --wait-timeout 300 rallly
./scripts/compose-custom.sh ps
./scripts/smoke-test.sh
```

Le téléchargement vérifie le SHA-256, puis l'import vérifie architecture,
utilisateur et révision applicative. Les fichiers téléchargés sont dans `.cache/`
(ignoré). L'artefact GitHub expire après trois jours ; l'image déjà importée reste
locale. Si nécessaire, relancer le workflow existant sur GitHub et importer
l'artefact du nouveau run. La publication durable dans un registre reste à faire.

`compose-custom.sh` charge les fichiers base, OIDC et custom. Il ne compile pas
l'image lors du démarrage. Sur un clone neuf, initialiser d'abord les dépendances
et le fournisseur Authentik avec le guide local, puis importer l'image et renseigner
les variables OIDC du `.env` privé.

Pour un serveur suffisamment dimensionné, le même build est reproductible depuis
le commit figé, sans checkout du fork sur le poste :

```bash
# Compilation lourde : utiliser la CI ou une VM disposant des ressources nécessaires.
docker compose -f compose.yaml -f compose.custom.yaml build rallly
```

La CI d'infrastructure contient également ce build depuis les sources. La
surcharge Compose utilise la même révision, le même Dockerfile et les mêmes
arguments que le workflow distant.

## Utilisation et SSO

URL : http://rallly.localhost:8080
Callback OIDC conservée : http://rallly.localhost:8080/api/auth/callback/oidc

```bash
./scripts/compose-custom.sh logs --tail=80 rallly
./scripts/compose-custom.sh restart rallly
```

Utiliser le wrapper pour les opérations sur la stack personnalisée. Les commandes
sans surcharge servent à l'image officielle d'initialisation ou au retour arrière.
Aucun sondage de 3025 n'est transféré automatiquement sur 8080.

## Sauvegarde et migrations

```bash
mkdir -p backups
chmod 700 backups
docker compose exec -T rallly-db pg_dump -U rallly -d rallly -Fc > backups/rallly-before-update.dump
chmod 600 backups/rallly-before-update.dump
```

Au démarrage, `prisma migrate deploy` applique les migrations manquantes. Ici, la
seule migration supplémentaire ajoute la capacité nullable par option ; les
sondages existants restent sans limite. Ne pas utiliser `db:reset` ou `down -v`.

Retour à l'image officielle en conservant les données :

```bash
docker compose -f compose.yaml -f compose.oidc.yaml up -d --no-deps --wait rallly
```

La colonne nullable supplémentaire peut rester en place. Restaurer une sauvegarde
est une opération distincte si une future évolution devient incompatible.

## Recette manuelle

1. Se connecter via Authentik sur 8080.
2. Vérifier les comptes autorisé/refusé et le nouvel invité externe.
3. Créer un sondage, définir une capacité de 1 et tenter deux réponses Oui sur
   la même option : la seconde doit être refusée.
4. Vérifier qu'une option passée est en lecture seule et qu'une option future
   accepte les votes, en conservant les anciens votes.
5. Redémarrer uniquement Rallly et vérifier les données.

Les résultats effectivement obtenus sont consignés dans `validation.md` ; la
recette ci-dessus ne constitue pas une preuve d'exécution de chaque scénario.
