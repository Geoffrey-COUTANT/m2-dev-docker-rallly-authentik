# Runbook de déploiement VM Énov

## Prérequis à obtenir

- Compte et droits campus requis.
- Connexion VPN NetBird.
- Clé SSH et accès autorisé à la VM.
- Ressources de VM suffisantes.
- URL/DNS et stratégie TLS validés avec les contraintes du campus.

Suivre la documentation publique indiquée dans le sujet :  
https://github.com/Enov-Salle-Serveur/Documentation_Public

## Procédure à finaliser

1. Obtenir les accès et créer la VM selon la documentation campus.
2. Installer/vérifier Docker et le plugin Compose selon les consignes autorisées.
3. Cloner le dépôt.
4. Préparer la configuration et les secrets propres à la VM.
5. Démarrer et vérifier les services.
6. Vérifier OIDC, les policies, l'e-mail et les fonctionnalités.
7. Documenter les différences entre local et VM.
8. Fournir au formateur une URL ou une session de démonstration ainsi que des comptes de test non sensibles.

Aucun déploiement distant n'est réalisé par ce squelette. Ne mettre les identifiants réels ni dans ce document ni dans Git.
