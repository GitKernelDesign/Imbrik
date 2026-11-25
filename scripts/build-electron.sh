#!/bin/sh
# Construit les applications Electron d'Imbrik.
#   Linux  : AppImage, en x86_64 et arm64 (construits depuis Linux x86_64)
#   Windows: installateur NSIS + version portable (construits depuis Linux)
#   macOS  : Imbrik.app zippé, en x64 (Intel) et arm64 (Apple Silicon)
#
# Les paquets macOS sont signés « ad hoc » par rcodesign (voir
# electron/scripts/mac-sign.js) : ils démarrent sur Mac, mais ne sont pas
# notariés par Apple.
#
# Usage : bash scripts/build-electron.sh [linux|win|mac|tout]
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
  echo "== AppImage : x86_64 + arm64 =="
  # Les deux architectures sont explicites : sur la ligne de commande, une
  # cible nommée prend le pas sur la liste « arch » de package.json.
  npx electron-builder --linux AppImage --x64 --arm64
fi

if [ "$CIBLE" = "win" ] || [ "$CIBLE" = "tout" ]; then
  echo "== Windows : installateur + portable =="
  # wine-shim.js remplace l'appel à wine (extraction du désinstalleur).
  # Voir l'en-tête du fichier. Avec wine installé, on peut s'en passer.
  NODE_OPTIONS="--require $ROOT/electron/scripts/wine-shim.js" \
    npx electron-builder --win nsis portable
fi

if [ "$CIBLE" = "mac" ] || [ "$CIBLE" = "tout" ]; then
  echo "== macOS : Intel (x64) + Apple Silicon (arm64) =="
  # macOS refuse un binaire non signé sur Apple Silicon : le crochet afterPack
  # (electron/scripts/mac-sign.js) signe le paquet avec rcodesign.
  if ! command -v rcodesign >/dev/null 2>&1 &&
     [ ! -x "$HOME/.cargo/bin/rcodesign" ]; then
    echo "   /!\\ rcodesign absent : paquet non signé, il ne démarrera pas" >&2
    echo "       sur Apple Silicon. Installation :" >&2
    echo "       cargo install apple-codesign --locked" >&2
  fi
  npx electron-builder --mac zip --x64 --arm64
fi

echo
echo "Artefacts dans electron/dist :"
ls -1 "$ROOT"/electron/dist/*.AppImage "$ROOT"/electron/dist/*.exe \
  "$ROOT"/electron/dist/*-mac.zip 2>/dev/null
