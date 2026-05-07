#!/usr/bin/env bash

set -e

# Directorio del script (siempre fiable)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Root del repo (ajusta niveles según tu estructura)
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

PROJECTS=$1

if [ -z "$PROJECTS" ]; then
  echo "Uso: all | filminas_defensa filminas_avances manuscrito plan_tesis indice_comentado"
  exit 1
fi

if [ "$PROJECTS" == "all" ]; then
  PROJECTS="filminas_defensa filminas_avances manuscrito plan_tesis indice_comentado"
fi

for p in $PROJECTS; do
  echo "Building $p..."
  make -C "$REPO_ROOT" PROJECT="$p"
done
