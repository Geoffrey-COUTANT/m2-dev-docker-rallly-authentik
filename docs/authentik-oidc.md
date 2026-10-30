# Authentik et Rallly : préparation du SSO

L'étape 2 démarre les services sans provider précréé. Les opérations ci-dessous sont à effectuer et démontrer dans l'interface ; elles ne sont pas présentées comme déjà réalisées.

## Fournisseur OIDC

1. Ouvrir `http://authentik.localhost:8080/if/flow/initial-setup/`, créer le mot de passe `akadmin` et ouvrir l'interface d'administration.
2. Applications > Providers : créer un fournisseur **OAuth2/OpenID Provider**, nom `Rallly`, flux d'autorisation explicite par défaut (ou implicite si choix documenté), client **confidentiel**, Client ID `rallly`.
3. URI de redirection **Strict** : `http://rallly.localhost:8080/api/auth/callback/oidc`.
4. Conserver les mappings de scopes `openid`, `profile`, `email`, une clé de signature et le mode d'émetteur par fournisseur par défaut. Les utilisateurs de test doivent avoir un email et un nom.
5. Créer une Application, nom Rallly, **slug `rallly`**, liée à ce fournisseur. URL de lancement `http://rallly.localhost:8080`.
6. Copier le secret client dans `OIDC_CLIENT_SECRET` de `.env`, sans le committer.
7. Vérifier la découverte dans le navigateur : `http://authentik.localhost:8080/application/o/rallly/.well-known/openid-configuration`.
8. Activer le complément :

```bash
./scripts/validate.sh --oidc
docker compose -f compose.yaml -f compose.oidc.yaml up -d --wait --wait-timeout 300
```

Rallly 4.16.3 utilise `OIDC_DISCOVERY_URL`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET` et PKCE. Le code de cette version conserve la callback `/api/auth/callback/oidc` mais indique explicitement que `OIDC_ISSUER_URL` n'est plus utilisé. Ne pas appliquer une ancienne recette sans vérifier la version.

## Deux groupes aux accès distincts

Créer `rallly-autorises` et `rallly-refuses`, puis un utilisateur de test dans chaque groupe avec des emails distincts. Dans l'Application Rallly, onglet Policy / Group / User Bindings, créer un binding autorisant le groupe `rallly-autorises` uniquement. Vérifier en navigation privée : connexion du membre autorisé, refus du membre sans binding. Un membre des deux groupes sera autorisé par le binding : garder les comptes de recette disjoints.

Cette règle contrôle l'accès au fournisseur OIDC. Elle ne crée pas automatiquement un administrateur Rallly et ne protège pas les connexions email ou votes invités. Restreindre ces chemins est un travail distinct si le scénario ou une feature l'exige.

## Invitation externe à réaliser

Créer un flow d'enrôlement dédié : stage Invitation (invitation requise), Identification pour les champs demandés, Prompt pour email/nom/mot de passe, User Write et User Login. Utiliser les modèles de flows Authentik si disponibles et contrôler les bindings/ordres dans cette version. Dans Directory > Invitations, créer une invitation à usage unique avec expiration, liée au flow et à l'email du compte de test. Le lien est de la forme `/if/flow/<slug>/?itoken=<jeton>` : utiliser celui généré par Authentik, ne pas fabriquer le jeton.

Transmettre le lien manuellement au compte de test ou configurer un Email stage utilisant Mailpit ; la création d'une invitation n'envoie pas nécessairement un email. Ajouter le nouveau compte au groupe autorisé par une action contrôlée de l'administrateur (ne jamais autoriser un groupe privilégié via un champ libre d'invitation). Tester expiration et second usage refusé. Conserver les captures sans jetons ni mots de passe.

## Recette

- Déconnexion complète, puis connexion OIDC avec le compte autorisé.
- Nom/email corrects visibles dans Rallly et session créée.
- Compte refusé bloqué par Authentik.
- Invitation utilisable une fois, compte créé, ajout au groupe puis connexion réussie.

La découverte seule ne prouve pas un SSO réussi : cette recette navigateur reste obligatoire.

## État local vérifié le 29 octobre 2026

Le fournisseur existant « Provider for rallly » (ID 2), client confidentiel `rallly`, est lié à l'application de slug `rallly`. La redirection stricte est `http://rallly.localhost:8080/api/auth/callback/oidc`. Le flux utilise le consentement explicite, les scopes openid/profile/email et PKCE.

Le secret initial a été recopié dans `.env`, sans être ajouté au dépôt. `COMPOSE_FILE=compose.yaml:compose.oidc.yaml` est renseigné dans ce `.env` local afin que les commandes ordinaires `docker compose` conservent le SSO activé.

Test navigateur réussi : bouton Authentik dans Rallly, consentement dans Authentik avec la session administrateur existante, retour authentifié sur `/setup` dans Rallly avec l'identité issue du fournisseur. Le profil Rallly reste à finaliser par l'utilisateur. Aucun mot de passe n'a été changé.

Les policies par groupe et l'invitation externe ne sont pas encore configurées ni validées. Le SSO activé ne désactive pas les autres méthodes de connexion Rallly.


## Correction du parcours d’invitation — 30 octobre 2026

Diagnostic réel : le stage `rallly-creation-compte-externe` créait des comptes
inactifs, sans groupe ; `invite-externe` existe ainsi mais reste inchangé.
L’ancien lien à usage unique n’existe plus. Aucun mot de passe n’a été modifié.

Après accord explicite de l’utilisateur :
- `create_users_as_inactive = false` ;
- groupe automatique de création : `rallly-autorises` (non administrateur) ;
- type de compte conservé : `external` ;
- application par défaut de la marque : `rallly` pour la destination des comptes externes ;
- invitation nominative de test : compte `invite-externe-2`, usage unique, durée 24 h.

Le flow garde son stage Invitation obligatoire et son exigence de session non
authentifiée. Test API sans invitation : `ak-stage-access-denied`, message
`Invalid invite/invite not found`. Le nouveau lien ouvre bien le formulaire
Username / Name / Email / Password / Password (repeat), avec identité préremplie.
Le jeton n’est volontairement pas enregistré dans ce document ni dans Git.

Validation encore à terminer par l’utilisateur : saisir le mot de passe dans le
formulaire ouvert, confirmer la création, puis vérifier le retour à Rallly via
Authentik. La présence du compte actif, du groupe et la connexion SSO doivent
être constatées après cette saisie ; elles ne sont pas encore revendiquées pour
ce nouvel invité. Dans cette version installée, le lien à usage unique est
consommé dès son passage au stage Invitation : conserver l’onglet ouvert jusqu’à
la fin du parcours. Recréer un lien si le parcours est abandonné et perdu.

Références : https://docs.goauthentik.io/users-sources/user/invitations/
et https://docs.goauthentik.io/add-secure-apps/flows-stages/stages/user_write


### Validation après intégration de l’image — 30 octobre 2026

Le compte `invite-externe-2` a terminé son inscription. Vérification réelle :
compte actif, type `external`, groupe `rallly-autorises`. Le parcours navigateur
Authentik → consentement OIDC → Rallly sur 8080 a réussi avec l’image du fork.
Le profil personnel de démonstration est finalisé et l’accueil Rallly est
accessible sous `invite-externe-2@lab.example.com`. Aucun mot de passe ni jeton
n’est enregistré dans le dépôt. Le précédent paragraphe décrivait l’état avant
cette recette ; la connexion de ce nouvel invité est maintenant vérifiée.
