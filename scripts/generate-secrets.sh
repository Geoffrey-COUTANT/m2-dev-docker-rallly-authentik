#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -e .env ]; then
  echo '.env existe : aucun secret remplacé.' >&2
  exit 1
fi
command -v openssl >/dev/null
umask 077
# noclobber empêche aussi un écrasement en cas de lancement simultané.
set -C
{
  printf 'COMPOSE_PROJECT_NAME=m2-docker\n'
  for key in RALLLY_DB_PASSWORD AUTHENTIK_DB_PASSWORD SECRET_PASSWORD AUTHENTIK_SECRET_KEY GARAGE_RPC_SECRET S3_SECRET_ACCESS_KEY; do
    printf '%s=%s\n' "$key" "$(openssl rand -hex 32)"
  done
  printf 'S3_ACCESS_KEY_ID=GK%s\n' "$(openssl rand -hex 12)"
  printf 'OIDC_CLIENT_ID=rallly\nOIDC_CLIENT_SECRET=\n'
} > .env
chmod 600 .env
echo 'Secrets créés dans .env (permissions 600). Aucun secret affiché.'
