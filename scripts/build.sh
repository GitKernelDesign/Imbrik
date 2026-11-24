#!/bin/sh
# Construit les paquets Imbrik avec Tauri.
# Usage : bash scripts/build.sh [cibles...]
#   ex. bash scripts/build.sh            -> deb + AppImage
#       bash scripts/build.sh deb        -> deb seul
#
# Les en-têtes WebKitGTK/GTK3 peuvent être fournis hors de /usr (machine sans
# root) via le préfixe $IMBRIK_DEPS ; voir scripts/dev-deps.sh.
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PREFIX=${IMBRIK_DEPS:-$HOME/imbrik-deps}

if [ -d "$PREFIX/usr/lib/x86_64-linux-gnu/pkgconfig" ]; then
  export PKG_CONFIG_PATH="$PREFIX/usr/lib/x86_64-linux-gnu/pkgconfig:$PREFIX/usr/share/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  export LIBRARY_PATH="$PREFIX/usr/lib/x86_64-linux-gnu${LIBRARY_PATH:+:$LIBRARY_PATH}"
fi

sh "$ROOT/scripts/prepare-ui.sh"

cd "$ROOT/src-tauri"
if [ "$#" -gt 0 ]; then
  exec cargo tauri build --bundles "$@"
fi
exec cargo tauri build
