// Pont entre l'application HTML (pensée pour un navigateur) et la webview Tauri.
// Ce fichier n'est injecté que dans ui-dist/index.html par scripts/prepare-ui.sh :
// Imbrik-v1.5.0.html reste utilisable tel quel dans un navigateur.
//
// Deux fonctions du navigateur n'existent pas dans une webview :
//   * le téléchargement d'un fichier via <a download> + URL.createObjectURL ;
//   * window.print(), sans effet dans WebKitGTK comme dans WebView2.
// On les redirige vers des commandes natives Rust.
(function () {
  "use strict";

  function dansTauri() {
    return !!(window.__TAURI__ && window.__TAURI__.core && window.__TAURI__.core.invoke);
  }

  function invoke(cmd, args) {
    return window.__TAURI__.core.invoke(cmd, args);
  }

  function installer() {
    // En navigateur, on ne touche à rien : le comportement d'origine est conservé.
    if (!dansTauri()) return;

    // --- 1. Téléchargements ----------------------------------------------
    // L'application crée un <a download href="blob:..."> puis appelle click().
    // On intercepte ce clic pour passer par une boîte « Enregistrer sous ».
    var clickOriginal = HTMLAnchorElement.prototype.click;

    HTMLAnchorElement.prototype.click = function () {
      var nom = this.getAttribute && this.getAttribute("download");
      var href = this.href || "";
      if (!nom || href.indexOf("blob:") !== 0) {
        return clickOriginal.apply(this, arguments);
      }
      fetch(href)
        .then(function (r) { return r.arrayBuffer(); })
        .then(function (buf) {
          return invoke("imbrik_save_export", {
            name: nom,
            data: Array.from(new Uint8Array(buf))
          });
        })
        .catch(function (e) { console.error("Export Imbrik :", e); });
      setTimeout(function () {
        try { URL.revokeObjectURL(href); } catch (_) {}
      }, 60000);
      return undefined;
    };

    // --- 2. Impression ---------------------------------------------------
    // On sérialise l'état courant (les étiquettes sont déjà dans le DOM, la
    // classe body porte le mode d'impression), on retire les scripts pour ne
    // pas relancer l'application, puis on ouvre le document dans le
    // navigateur par défaut, qui affiche la boîte de dialogue d'impression.
    window.print = function () {
      var racine = document.documentElement.cloneNode(true);
      Array.prototype.forEach.call(racine.querySelectorAll("script"), function (s) {
        s.parentNode.removeChild(s);
      });
      var html =
        "<!DOCTYPE html>" +
        racine.outerHTML +
        '<script>window.addEventListener("load",function(){setTimeout(function(){window.print();},150);});<' +
        "/script>";
      invoke("imbrik_print_html", { html: html }).catch(function (e) {
        console.error("Impression Imbrik :", e);
      });
    };
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", installer, { once: true });
  } else {
    installer();
  }
})();
