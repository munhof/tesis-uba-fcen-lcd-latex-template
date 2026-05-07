#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

IMAGE_NAME="${LATEX_IMAGE:-tesis-latex:latest}"
ENGINE="${CONTAINER_ENGINE:-${ENGINE:-docker}}"
PROJECT="${1:-}"

usage() {
  cat <<EOF
Uso:
  $0 <proyecto|all>

Proyectos:
  manuscrito
  plan_tesis
  filminas_avances
  filminas_defensa
  indice_comentado
  all

Configuracion opcional:
  CONTAINER_ENGINE=docker|podman   Motor de contenedores. Default: docker
  LATEX_IMAGE=tesis-latex:latest   Nombre de la imagen local
  BUILD_IMAGE=0                    No reconstruir la imagen antes de compilar

Ejemplos:
  $0 manuscrito
  CONTAINER_ENGINE=podman $0 all
  BUILD_IMAGE=0 LATEX_IMAGE=tesis-latex:latest $0 plan_tesis
EOF
}

if [ -z "$PROJECT" ] || [ "$PROJECT" = "-h" ] || [ "$PROJECT" = "--help" ]; then
  usage
  exit 0
fi

if ! command -v "$ENGINE" >/dev/null 2>&1; then
  echo "Error: no se encontro '$ENGINE'. Configurar CONTAINER_ENGINE=docker o CONTAINER_ENGINE=podman."
  exit 1
fi

case "$PROJECT" in
  manuscrito|plan_tesis|filminas_avances|filminas_defensa|indice_comentado|all) ;;
  *)
    echo "Error: proyecto desconocido '$PROJECT'."
    usage
    exit 1
    ;;
esac

if [ "${BUILD_IMAGE:-1}" != "0" ]; then
  echo "Construyendo imagen $IMAGE_NAME con $ENGINE..."
  "$ENGINE" build \
    -t "$IMAGE_NAME" \
    -f "$REPO_ROOT/docker/latex/Dockerfile" \
    "$REPO_ROOT"
fi

if [ "$PROJECT" = "all" ]; then
  MAKE_TARGET="all-projects"
  MAKE_ARGS=("$MAKE_TARGET")
else
  MAKE_ARGS=("PROJECT=$PROJECT" "all")
fi

echo "Compilando '$PROJECT' con $ENGINE..."
"$ENGINE" run --rm \
  -v "$REPO_ROOT:/workspace" \
  -w /workspace \
  "$IMAGE_NAME" \
  make "${MAKE_ARGS[@]}"
