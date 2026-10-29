# Sécurité — règles du dépôt

- Ne jamais committer `.env`, mots de passe, jetons OAuth/OIDC, clés privées ou certificats privés.
- `.env.example` ne contient que des valeurs factices et des noms de variables à confirmer.
- Ne pas publier de ports de base de données sur l'hôte, sauf nécessité de diagnostic documentée et temporaire.
- Ne pas exposer directement les interfaces d'administration.
- Utiliser des volumes persistants pour les données nécessaires.
- Réduire les privilèges et les ports exposés ; éviter le mode `privileged`.
- Les images et versions seront épinglées après vérification de compatibilité.
- Faire un scan d'image et commenter les résultats avant la soutenance.
- En cas de fuite d'un secret : le révoquer/renouveler immédiatement, puis supprimer sa présence dans l'historique Git si nécessaire.

Les mesures ci-dessus sont des exigences de travail ; elles ne signifient pas que la stack est déjà durcie.
