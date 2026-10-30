# Sécurité du laboratoire

`.env`, sauvegardes et secrets sont hors dépôt et hors ZIP. Le script génère des secrets aléatoires hexadécimaux, compatibles avec l'URL PostgreSQL, et refuse l'écrasement. Ne pas régénérer les secrets d'une installation existante.

Traefik et Mailpit utilisent un UID explicite non-root ; l'image officielle Rallly utilise `nextjs`. Les bases et Garage conservent leur initialisation upstream. Authentik utilise l'UID 1000 de son image sans `user: root` forcé ; les éventuels besoins de droits sur `/data` restent à vérifier lors du premier démarrage effectif. Pas de socket Docker, pas d'outpost automatique.

Tous les services ont `no-new-privileges`. Les capabilities sont supprimées pour proxy, Mailpit et Rallly. Le système de fichiers Traefik est en lecture seule. Ne pas imposer aveuglément ces réglages aux services qui initialisent des volumes.

Un seul port est publié sur 127.0.0.1. HTTP et Mailpit sont réservés au laboratoire local. Les groupes Authentik limitent le SSO mais ne bloquent pas tous les parcours Rallly. Un accès public exige une analyse de ces parcours, TLS, SMTP réel, sauvegardes et scan des images.

## Scan à réaliser et commenter

Avec Docker Scout installé :

```bash
docker scout cves lukevella/rallly:4.16.3
docker scout cves ghcr.io/goauthentik/server:2026.8.5
```

Faire de même pour chaque dépendance ; consigner les CVE, correctifs, faux positifs justifiés et limites. Aucun scan CVE réussi n'est revendiqué sans rapport. Les images sont des dépendances tierces, et un tag précis n'est pas une garantie d'absence de faille.
