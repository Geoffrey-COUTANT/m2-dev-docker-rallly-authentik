# Déploiement de Rallly avec Authentik

La stack construit notre fork depuis le sous-module `rallly` et lance Authentik
(serveur et worker) avec une base PostgreSQL dédiée. Les données sont conservées
dans des volumes Docker. La configuration suit le
[Compose officiel d’Authentik](https://docs.goauthentik.io/compose.yml).

Avec Docker et Docker Compose 2.24 ou supérieur :

```shell
git submodule update --init --recursive
# Uniquement si .env n'existe pas encore :
cp .env.example .env
chmod 600 .env
```

Renseigner les quatre secrets vides du `.env` avec les résultats de ces commandes
(une commande par variable, conserver ces secrets après initialisation) :

```shell
openssl rand -hex 32  # RALLLY_SECRET
openssl rand -hex 32  # AUTHENTIK_DB_PASSWORD
openssl rand -hex 60  # AUTHENTIK_SECRET_KEY
openssl rand -hex 32  # OIDC_CLIENT_SECRET
```

Le `.env` local est déjà renseigné avec des secrets générés. Le mot de passe de la
base Rallly reste `postgres` pour conserver la compatibilité avec un volume existant ;
pour une nouvelle installation, le remplacer par une valeur hexadécimale.
Modifier un mot de passe dans `.env` ne change pas celui d'une base déjà initialisée.

```shell
docker compose config --quiet
docker compose up -d --build
```

- Rallly : <http://localhost:3000>
- Authentik : <http://authentik.localhost:9000>

Au premier accès à Authentik, définir le mot de passe du compte `akadmin`.
Son adresse mail initiale est définie par `AUTHENTIK_BOOTSTRAP_EMAIL` ; chaque
utilisateur doit avoir une adresse mail renseignée pour se connecter à Rallly.
Les ports, la version, le nom de base et l'utilisateur Authentik se règlent dans `.env`.
Cette version utilise PostgreSQL sans Redis. Le worker n'a pas accès au socket Docker ;
les éventuels outposts externes doivent être déployés manuellement.

La connexion par mail de Rallly est désactivée (`EMAIL_LOGIN_ENABLED=false`).
Rallly redirige automatiquement vers Authentik. Le blueprint monté dans le worker
crée l'application OIDC `rallly`, son fournisseur et les scopes `openid profile email`.
Le client ID et le secret sont partagés via `.env` ; aucune saisie manuelle de ces
valeurs dans Authentik n'est nécessaire. Rallly attend que le fournisseur soit prêt.

Le nom `authentik.localhost` pointe vers la boucle locale dans les navigateurs
compatibles avec `.localhost`, et vers le serveur Authentik sur le réseau Docker.
Si le navigateur ne le résout pas, ajouter `127.0.0.1 authentik.localhost` dans le
fichier hosts de la machine. Utiliser cette adresse pour Authentik afin que l'émetteur
OIDC reste identique dans le navigateur et dans Rallly.

Voir [la configuration et la vérification OIDC](docs/authentik-oidc.md).
Les paramètres SMTP facultatifs de Rallly peuvent rester dans `rallly/apps/web/.env`.

```shell
docker compose ps
docker compose logs -f authentik_server authentik_worker
docker compose down  # conserve les données
```
