#!/bin/sh
# Prépare le dossier servi par la webview Tauri.
# La source unique de vérité reste Imbrik-v<version>.html à la racine :
# ui-dist/index.html en est une copie, avec le pont natif injecté ainsi que
# le script de génération de ui-dist/bridge.js.
set -e
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC=$(ls "$ROOT"/Imbrik-v*.html | sort -V | tail -1)

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

echo "ui-dist/index.html <- $(basename "$SRC") (+ bridge.js)"
