#!/usr/bin/env bash
set -euo pipefail

plugins=(
  plannotator/herdr-annotate
)

command -v herdr >/dev/null || { echo "herdr not installed, skipping plugins" >&2; exit 0; }

installed=$(herdr plugin list 2>/dev/null || true)
for src in "${plugins[@]}"; do
  if grep -q "github:${src}@" <<<"$installed"; then
    echo "herdr plugin ${src} already installed"
  else
    herdr plugin install --yes "$src"
  fi
done
