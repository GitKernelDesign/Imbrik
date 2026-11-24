// Imbrik — optimiseur de découpe de panneaux
// Copyright (C) 2025 Imbrik
//
// Ce programme est un logiciel libre : vous pouvez le redistribuer et/ou le
// modifier selon les termes de la GNU General Public License v3.0 (ou
// ultérieure) publiée par la Free Software Foundation. Voir LICENSE.

const { app, BrowserWindow, Menu, shell } = require("electron");
const path = require("path");

// L'interface est le fichier HTML autonome d'Imbrik, copié dans app/ par
// scripts/prepare-ui.sh : aucune couche applicative n'est ajoutée ici.
const PAGE = path.join(__dirname, "app", "index.html");
const ICONE = path.join(__dirname, "build", "icon.png");

function creerFenetre() {
  const fenetre = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 960,
    minHeight: 620,
    title: "IMBRIK 1.5.0 — Optimiseur de découpe",
    icon: ICONE,
    backgroundColor: "#eef1f6",
    autoHideMenuBar: true,
    show: false,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      spellcheck: false
    }
  });

  fenetre.once("ready-to-show", () => fenetre.show());
  fenetre.loadFile(PAGE);

  // Les liens du menu ☰ (site, licence) s'ouvrent dans le navigateur,
  // jamais dans une fenêtre de l'application.
  fenetre.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith("http://") || url.startsWith("https://")) {
      shell.openExternal(url);
    }
    return { action: "deny" };
  });

  return fenetre;
}

// L'application possède son propre menu (burger) : pas de barre de menus.
Menu.setApplicationMenu(null);

app.whenReady().then(() => {
  creerFenetre();
  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) creerFenetre();
  });
});

app.on("window-all-closed", () => app.quit());
