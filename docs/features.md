# Fonctionnalités Rallly — suivi au 30 octobre 2026

Les deux fonctionnalités catalogue sont développées dans le fork
https://github.com/Geoffrey-COUTANT/rallly et fusionnées dans main.
La confirmation de leur attribution par le formateur reste à consigner.

| Fonctionnalité | État | Preuve |
|---|---|---|
| Catalogue n°3 : plafond de participants par créneau | Développée, testée, fusionnée | https://github.com/Geoffrey-COUTANT/rallly/pull/1 |
| Catalogue n°5 : bloquer le vote sur dates/heures passées | Développée, testée, fusionnée | https://github.com/Geoffrey-COUTANT/rallly/pull/2 |
| Fonctionnalité libre | À définir et développer | Aucune implémentation revendiquée |

## Quota par créneau

Un responsable authentifié définit une limite commune, appliquée indépendamment
à chaque option. Seuls les Oui occupent une place. Dépasser la capacité provoque
un refus explicite et atomique, même pour des requêtes concurrentes.
Documentation applicative : `docs/option-capacity.md` dans le fork.

## Créneaux passés

Un créneau avec horaire est verrouillé à son début ; une date entière reste
ouverte jusqu’à la fin du jour dans le fuseau du sondage (UTC par défaut).
Les choix sont désactivés dans l’interface et vérifiés côté serveur. Les votes
historiques sont conservés lorsqu’une réponse future est modifiée.
Documentation applicative : `docs/past-option-votes.md` dans le fork.

## Validation et démonstration

La suite locale a validé 1 139 tests unitaires et 19 tests PostgreSQL (9 pour les
créneaux passés et 10 pour les quotas), avec TypeScript, Biome et build production.
La CI de main après fusion des deux PR est verte :
https://github.com/Geoffrey-COUTANT/rallly/actions/runs/41039321875

L’image `m2-rallly:413ff340d` se construit depuis le commit de main figé contenant
les deux features. Voir [l’intégration dans la stack](integration-fork.md).
Le transfert des sondages de la démo 3025 vers la stack 8080 n’est pas effectué.

À compléter pour la soutenance : captures des deux features dans la stack
intégrée, scénario live, feature libre et validation d’attribution du formateur.
Les PR sont fusionnées sur notre fork : cela ne constitue pas une acceptation
upstream et ne donne pas automatiquement le bonus du sujet.
