#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [ "${1:-}" = up ] && ! docker image inspect m2-rallly:413ff340d >/dev/null 2>&1; then
  echo 'Image du fork absente. Importer le build GitHub avec scripts/fetch-custom-image.sh avant de démarrer.' >&2
  exit 1
fi
exec docker compose -f compose.yaml -f compose.oidc.yaml -f compose.custom.yaml "$@"
