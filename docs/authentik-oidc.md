# Authentik — OIDC, policies et invitation externe

## Configuration OIDC

Le Compose transmet à Rallly `EMAIL_LOGIN_ENABLED=false`, `OIDC_NAME`,
`OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET` et l'URL de découverte construite à partir
de `AUTHENTIK_HOST` et `AUTHENTIK_HTTP_PORT`. Les comptes Rallly sont créés à la
première connexion SSO (`REGISTRATION_ENABLED=true`). La connexion par mail est masquée
et le fork redirige automatiquement vers Authentik.

Le worker charge `docker/authentik/blueprints/rallly.yaml`, qui crée :

- l'application de slug `rallly` et un fournisseur confidentiel en Authorization Code ;
- les scopes `openid`, `profile`, `email`, avec les mappings Authentik par défaut ;
- une clé de signature et les flows d'autorisation et d'invalidation standards ;
- la redirection stricte `${RALLLY_BASE_URL}/api/auth/callback/oidc`, utilisée par ce fork.

Les secrets sont lus avec les [tags de blueprint Authentik](https://docs.goauthentik.io/customize/blueprints/v1/tags/).
Le worker [charge automatiquement les blueprints locaux](https://docs.goauthentik.io/customize/blueprints/).
Rallly utilise PKCE. Le healthcheck du serveur attend que l'URL de découverte soit
disponible avant de démarrer Rallly.

Valeurs locales par défaut :

| Paramètre | Valeur |
| --- | --- |
| URL Rallly | `http://localhost:3000` |
| URL Authentik | `http://authentik.localhost:9000` |
| Découverte | `http://authentik.localhost:9000/application/o/rallly/.well-known/openid-configuration` |
| Callback | `http://localhost:3000/api/auth/callback/oidc` |
| Client ID | `rallly` |

`AUTHENTIK_HOST` est aussi un alias DNS Docker du serveur. Le navigateur doit
résoudre ce même nom vers la machine Docker ; ajouter
`127.0.0.1 authentik.localhost` au fichier hosts si nécessaire. `localhost` seul ne
convient pas comme nom Authentik pour OIDC : dans Rallly, il désignerait Rallly lui-même.
Le port HTTP interne suit `AUTHENTIK_HTTP_PORT` pour conserver les mêmes URLs.
Ce paramétrage HTTP est destiné au développement local.

## Vérification

```bash
docker compose up -d --build --wait
docker compose ps
docker compose logs --tail=100 authentik_worker rallly_selfhosted
```

Définir le mot de passe initial d'`akadmin` depuis l'interface Authentik si nécessaire.
`AUTHENTIK_BOOTSTRAP_EMAIL` ne s'applique qu'à l'initialisation : sur une base existante,
renseigner une adresse mail dans le profil de l'utilisateur Authentik.
Les comptes sans adresse mail ne peuvent pas être créés dans Rallly.

Ouvrir `http://localhost:3000/login`, se connecter dans Authentik avec un compte
possédant une adresse mail, puis vérifier le retour à une session Rallly authentifiée.

Après modification du client ID, du secret ou de `RALLLY_BASE_URL` (sans slash final),
recréer les services et réappliquer explicitement le blueprint : une modification
d'environnement seule ne change pas le fichier surveillé par Authentik.

```bash
docker compose up -d
docker compose exec authentik_worker ak apply_blueprint custom/rallly.yaml
```

Le formulaire de connexion peut être réactivé avec `EMAIL_LOGIN_ENABLED=true` ;
cela demande un SMTP fonctionnel pour l'envoi des codes par mail.

## Checklist des droits

- [ ] Créer au moins deux groupes Authentik.
- [ ] Définir des droits d'accès distincts via les policies/bindings appropriés.
- [ ] Tester un utilisateur autorisé.
- [ ] Tester un utilisateur non autorisé.
- [ ] Documenter les résultats attendus et observés.

## Invitation externe

- [ ] Configurer le flux d'invitation adapté.
- [ ] Configurer le SMTP de laboratoire si le flux choisi l'exige.
- [ ] Inviter une adresse de test contrôlée par l'équipe.
- [ ] Vérifier la réception, l'activation et l'accès.
- [ ] Documenter les étapes et les limites.

Ne pas considérer ces cases comme réalisées avant d'avoir testé le flux réel.
