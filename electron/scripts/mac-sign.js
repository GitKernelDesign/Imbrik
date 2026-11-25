// Signature ad hoc des applications macOS construites depuis Linux.
// Copyright (C) 2025 Imbrik — GPL-3.0-or-later
//
// macOS refuse de lancer un binaire non signé sur Apple Silicon (arm64) et
// invalide la signature d'origine d'Electron dès qu'on ajoute app.asar ou
// qu'on renomme l'exécutable. Electron-builder ne signe que sur macOS ; ce
// crochet « afterPack » signe donc le paquet avec rcodesign (apple-codesign),
// l'équivalent libre de `codesign`, qui fonctionne aussi sur Linux.
//
// Signature *ad hoc* : aucune identité Apple n'est requise, mais l'application
// n'est pas notariée. Sur macOS il faut donc l'autoriser une fois :
//   Réglages Système → Confidentialité et sécurité → « Ouvrir quand même »
// ou, en ligne de commande :
//   xattr -dr com.apple.quarantine /Applications/Imbrik.app
//
// Sur macOS (ou si un certificat Developer ID est fourni), ce crochet ne fait
// rien : c'est `codesign`, appelé par electron-builder, qui signe le paquet.
//
// Installation de rcodesign :
//   cargo install apple-codesign --locked
//   (ou https://github.com/indygreg/apple-platform-rs/releases)

const { execFileSync } = require("child_process");
const fs = require("fs");
const os = require("os");
const path = require("path");

function trouverRcodesign() {
  const candidats = [
    process.env.RCODESIGN,
    path.join(os.homedir(), ".cargo", "bin", "rcodesign"),
    "/usr/local/bin/rcodesign",
    "/opt/homebrew/bin/rcodesign",
    "/usr/bin/rcodesign"
  ];
  for (const candidat of candidats) {
    if (!candidat) continue;
    try {
      fs.accessSync(candidat, fs.constants.X_OK);
      return candidat;
    } catch {
      /* candidat suivant */
    }
  }
  return null;
}

async function signerMac(context) {
  // Uniquement pour une cible macOS construite ailleurs que sur macOS.
  if (context.electronPlatformName !== "darwin") return;
  if (process.platform === "darwin") return;

  const produit = context.packager.appInfo.productFilename;
  const paquet = path.join(context.appOutDir, `${produit}.app`);
  if (!fs.existsSync(paquet)) {
    throw new Error(`[mac-sign] paquet introuvable : ${paquet}`);
  }

  const rcodesign = trouverRcodesign();
  if (!rcodesign) {
    console.warn(
      "[mac-sign] rcodesign introuvable : " +
        `${produit}.app reste non signé (il ne démarrera pas sur Apple Silicon).\n` +
        "           Installez-le avec : cargo install apple-codesign --locked"
    );
    return;
  }

  console.log(`  • signature ad hoc (rcodesign) de ${path.basename(paquet)}`);
  execFileSync(rcodesign, ["sign", paquet], { stdio: "inherit" });
}

module.exports = signerMac;
module.exports.default = signerMac;
