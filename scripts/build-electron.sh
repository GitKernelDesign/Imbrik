#!/bin/sh
# Construit les applications Electron d'Imbrik.
#   Linux  : AppImage
#   Windows: installateur NSIS + version portable (construits depuis Linux)
#
# Usage : bash scripts/build-electron.sh [linux|win|tout]
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CIBLE=${1:-tout}

# Node n'est pas forcément dans le PATH : on accepte un Node local.
if ! command -v node >/dev/null 2>&1; then
  for d in "$HOME/outils/node/bin" "$HOME/.local/node/bin"; do
    [ -x "$d/node" ] && PATH="$d:$PATH" && break
  done
fi
command -v node >/dev/null 2>&1 || {
  echo "Node.js est requis (https://nodejs.org, ou archive décompressée dans ~/outils/node)." >&2
  exit 1
}

export ELECTRON_CACHE=${ELECTRON_CACHE:-$HOME/.cache/electron}
export ELECTRON_BUILDER_CACHE=${ELECTRON_BUILDER_CACHE:-$HOME/.cache/electron-builder}

sh "$ROOT/scripts/prepare-ui.sh"

cd "$ROOT/electron"
if [ ! -d node_modules ]; then
  echo "== Installation des dépendances =="
  npm install --no-audit --no-fund
fi
# npm 11 n'exécute plus les scripts d'installation : le binaire Electron est
# téléchargé explicitement.
[ -d node_modules/electron/dist ] || node node_modules/electron/install.js

if [ "$CIBLE" = "linux" ] || [ "$CIBLE" = "tout" ]; then
  echo "== AppImage =="
  npx electron-builder --linux AppImage
fi

if [ "$CIBLE" = "win" ] || [ "$CIBLE" = "tout" ]; then
  echo "== Windows : installateur + portable =="
  # wine-shim.js remplace l'appel à wine (extraction du désinstalleur).
  # Voir l'en-tête du fichier. Avec wine installé, on peut s'en passer.
  NODE_OPTIONS="--require $ROOT/electron/scripts/wine-shim.js" \
    npx electron-builder --win nsis portable
fi

echo
echo "Artefacts dans electron/dist :"
ls -1 "$ROOT"/electron/dist/*.AppImage "$ROOT"/electron/dist/*.exe 2>/dev/null
