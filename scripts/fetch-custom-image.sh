#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
run_id=${1:?Usage: ./scripts/fetch-custom-image.sh ID_DU_RUN_GITHUB}
case "$run_id" in *[!0-9]*|'') echo 'ID du run invalide' >&2; exit 1;; esac
artifact_dir="$PWD/.cache/rallly-image/$run_id"
mkdir -p "$artifact_dir"
if [ ! -f "$artifact_dir/rallly-arm64.tar.gz" ] || [ ! -f "$artifact_dir/rallly-arm64.tar.gz.sha256" ]; then
  gh run download "$run_id" --repo Geoffrey-COUTANT/rallly --name rallly-project-arm64 --dir "$artifact_dir"
fi
(cd "$artifact_dir" && shasum -a 256 -c rallly-arm64.tar.gz.sha256)
docker load -i "$artifact_dir/rallly-arm64.tar.gz"
test "$(docker image inspect m2-rallly:413ff340d --format '{{.Architecture}}')" = arm64
test "$(docker image inspect m2-rallly:413ff340d --format '{{.Config.User}}')" = nextjs
test "$(docker image inspect m2-rallly:413ff340d --format '{{index .Config.Labels "org.opencontainers.image.revision"}}')" = 413ff340dd2dab415e1779776262ce9a402a71ec
