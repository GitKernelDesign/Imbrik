// Contournement de wine pour la construction des cibles NSIS (setup et
// portable) depuis Linux.
//
// Pour produire un installateur, electron-builder construit d'abord un
// installateur temporaire dont le seul rôle est d'écrire le désinstalleur,
// puis il l'exécute. Sur Windows et macOS il le lance directement ; sur Linux
// il appelle `wine`, absent de nombreuses machines.
//
// Electron-builder embarque déjà un lecteur d'archive NSIS, utilisé sur macOS
// Catalina pour le même besoin : il extrait le désinstalleur du binaire sans
// l'exécuter. On substitue ce chemin à l'appel à wine.
//
// Utilisation :
//   NODE_OPTIONS="--require electron/scripts/wine-shim.js" npx electron-builder --win nsis portable

const path = require("path");
const fs = require("fs");

const LIB = "app-builder-lib/out";

let WineVmManager;
try {
  ({ WineVmManager } = require(`${LIB}/vm/WineVm.js`));
} catch (e) {
  // version d'electron-builder sans gestionnaire wine : rien à faire
  module.exports = {};
  return;
}

const { UninstallerReader } = require(`${LIB}/targets/nsis/nsisUtil.js`);

WineVmManager.prototype.exec = async function (file) {
  // même convention que NsisTarget.computeScriptAndSignUninstaller :
  // <nom de l'installateur>__uninstaller.exe, dans le même dossier
  const cible = path.join(
    path.dirname(file),
    `${path.basename(file, "exe")}__uninstaller.exe`
  );

  await UninstallerReader.exec(file, cible);

  if (!fs.existsSync(cible)) {
    throw new Error(
      `désinstalleur non extrait de ${file} (attendu : ${cible})`
    );
  }
  return "";
};
