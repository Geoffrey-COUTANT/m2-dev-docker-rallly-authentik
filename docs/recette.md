# Recette de l'étape 2

| Contrôle | Action | Résultat attendu |
|---|---|---|
| Secrets | Générateur puis second lancement | .env mode 600 ; second lancement refusé, fichier inchangé |
| Compose | scripts/validate.sh | Code 0 |
| Démarrage | compose up --wait | Services démarrés, sondes disponibles saines |
| Proxy | scripts/smoke-test.sh | HTTP 2xx ou 3xx pour les trois hôtes |
| Isolation | compose ps | Seul 127.0.0.1:8080 publié |
| Rallly | Créer un sondage, répondre en navigation privée | Réponse enregistrée |
| SMTP | Demander un code de connexion Rallly | Message reçu dans Mailpit |
| S3 | Charger une image/avatar si proposé | Objet stocké et relu après redémarrage |
| Persistance | down puis up sans -v | Sondage et données conservés |
| Authentik | Initial setup | akadmin peut se connecter |
| OIDC | Guide authentik-oidc.md | Connexion, refus par groupe et invitation démontrés |

Les résultats effectivement obtenus sont consignés dans validation.md. Une case attendue ici n'est pas une preuve de réussite.
