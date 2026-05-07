#!/usr/bin/env bash

set -e

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

echo "Extracting annotated index from manuscript..."
cd "$REPO_ROOT/indice_comentado"
python3 extract_index.py

echo "Building indice_comentado..."
make -C "$REPO_ROOT" PROJECT="indice_comentado"
