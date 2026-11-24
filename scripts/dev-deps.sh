#!/bin/sh
# Installe dans un préfixe local les en-têtes de développement nécessaires à la
# compilation de Tauri, sans avoir les droits root.
#
#   bash scripts/dev-deps.sh [préfixe]      # défaut : $HOME/imbrik-deps
#
# Sur une machine où vous avez root, la voie normale reste :
#   sudo apt install libwebkit2gtk-4.1-dev build-essential curl wget file \
#     libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev
set -e
PREFIX=${1:-${IMBRIK_DEPS:-$HOME/imbrik-deps}}
TRAVAIL=${TMPDIR:-/tmp}/imbrik-dev-deps
mkdir -p "$TRAVAIL" "$PREFIX"

PAQUETS="libwebkit2gtk-4.1-dev libgtk-3-dev libsoup-3.0-dev
libjavascriptcoregtk-4.1-dev libatk1.0-dev libatk-bridge2.0-dev
libatspi2.0-dev libdbus-1-dev librsvg2-dev libssl-dev"

echo "== Téléchargement des paquets -dev =="
cd "$TRAVAIL"
# shellcheck disable=SC2086
apt-get download $PAQUETS

echo "== Extraction dans $PREFIX =="
for d in ./*.deb; do dpkg -x "$d" "$PREFIX"; done

echo "== Réécriture des chemins des fichiers .pc =="
find "$PREFIX" -name '*.pc' -type f -print0 |
  xargs -0 sed -i "s|/usr/|$PREFIX/usr/|g; s|^prefix=/usr\$|prefix=$PREFIX/usr|"

# Les fichiers .pc déclarent des liens vers des bibliothèques versionnées qui
# ne sont pas dans le paquet -dev : on les pointe vers la bibliothèque système.
echo "== Résolution des liens symboliques =="
for l in "$PREFIX"/usr/lib/x86_64-linux-gnu/*.so; do
  [ -L "$l" ] || continue
  [ -e "$l" ] && continue
  base=$(basename "$(readlink "$l")")
  [ -e "/usr/lib/x86_64-linux-gnu/$base" ] && ln -sf "/usr/lib/x86_64-linux-gnu/$base" "$l"
done

echo
echo "Préfixe prêt : $PREFIX"
echo "Construisez avec : IMBRIK_DEPS=$PREFIX bash scripts/build.sh"
