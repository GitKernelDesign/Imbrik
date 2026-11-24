#!/bin/sh
# Prépare les copies de l'interface servies par les deux empaqueteurs.
# La source unique de vérité reste Imbrik-v<version>.html à la racine.
#
#   ui-dist/index.html       -> Tauri, avec le pont natif bridge.js injecté
#   electron/app/index.html  -> Electron, copie brute (Electron sait déjà
#                               télécharger un fichier et imprimer)
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC=$(ls "$ROOT"/Imbrik-v*.html | sort -V | tail -1)

# --- Electron : copie brute ------------------------------------------------
mkdir -p "$ROOT/electron/app"
cp "$SRC" "$ROOT/electron/app/index.html"

# --- Tauri : copie + pont natif -------------------------------------------
mkdir -p "$ROOT/ui-dist"
cp "$ROOT/src-tauri/src/bridge.js" "$ROOT/ui-dist/bridge.js"

# injection de <script src="bridge.js"></script> juste avant </head>
python3 - "$SRC" "$ROOT/ui-dist/index.html" <<'PY'
import sys

src, dest = sys.argv[1], sys.argv[2]
html = open(src, encoding="utf-8").read()
tag = '<script src="bridge.js"></script>\n'
if "bridge.js" not in html:
    i = html.lower().find("</head>")
    if i == -1:
        raise SystemExit("balise </head> introuvable")
    html = html[:i] + tag + html[i:]
open(dest, "w", encoding="utf-8").write(html)
PY

echo "ui-dist/index.html      <- $(basename "$SRC") (+ bridge.js)"
echo "electron/app/index.html <- $(basename "$SRC")"
