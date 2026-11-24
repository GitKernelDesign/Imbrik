#!/bin/sh
# Compile la version Windows d'Imbrik depuis Linux (cross-compilation).
#
#   bash scripts/build-windows.sh
#
# Prérequis (machine Linux) :
#   rustup target add x86_64-pc-windows-msvc
#   cargo install cargo-xwin            # ou le binaire précompilé des releases
#   apt install llvm lld                # llvm-rc et lld-link
#   apt install nsis                    # makensis (installateur)
#
# cargo-xwin télécharge le CRT et le SDK Microsoft dans ~/.cache/cargo-xwin.
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CIBLE=x86_64-pc-windows-msvc

sh "$ROOT/scripts/prepare-ui.sh"

cd "$ROOT/src-tauri"
echo "== Compilation du binaire =="
cargo xwin build --release --target "$CIBLE"

echo "== Génération de l'installateur NSIS =="
# makensis.exe est cherché par le bundler : sur Linux il faut un makensis natif
# exposé sous ce nom, avec les données NSIS dans ~/.cache/tauri/NSIS.
if ! command -v makensis.exe >/dev/null 2>&1; then
  echo "AVERTISSEMENT : makensis.exe introuvable, l'installateur ne sera pas produit." >&2
  echo "  cp \"\$(command -v makensis)\" ~/.cargo/bin/makensis.exe" >&2
  exit 0
fi

cargo tauri build --target "$CIBLE" --bundles nsis --runner cargo-xwin

echo
echo "Binaire portable : src-tauri/target/$CIBLE/release/imbrik.exe"
echo "Installateur     : src-tauri/target/$CIBLE/release/bundle/nsis/"
