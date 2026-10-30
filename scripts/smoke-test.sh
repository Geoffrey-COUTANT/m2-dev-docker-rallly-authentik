#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
for host in rallly.localhost authentik.localhost mailpit.localhost; do
  code=$(curl --max-time 15 --noproxy '*' --resolve "$host:8080:127.0.0.1" -s -o /dev/null -w '%{http_code}' "http://$host:8080/")
  case "$code" in
    2??|3??) echo "$host : HTTP $code" ;;
    *) echo "$host : échec HTTP $code" >&2; exit 1 ;;
  esac
done
docker compose exec -T rallly-db pg_isready -U rallly -d rallly
docker compose exec -T authentik-db pg_isready -U authentik -d authentik
docker compose exec -T garage /garage stats -a
echo 'Services accessibles. Les parcours navigateur restent à tester (voir docs/recette.md).'
