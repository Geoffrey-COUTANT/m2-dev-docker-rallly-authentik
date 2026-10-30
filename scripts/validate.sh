#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
bash -n scripts/generate-secrets.sh scripts/validate.sh scripts/smoke-test.sh scripts/compose-custom.sh scripts/fetch-custom-image.sh
docker compose config --quiet
docker compose -f compose.yaml -f compose.custom.yaml config --quiet
if [ "${1:-}" = --oidc ]; then
  docker compose -f compose.yaml -f compose.oidc.yaml -f compose.custom.yaml config --quiet
fi
echo 'Syntaxe des scripts et modèle Compose valides.'
