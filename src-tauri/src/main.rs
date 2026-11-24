// Imbrik — optimiseur de découpe de panneaux
// Copyright (C) 2025 Imbrik
//
// Ce programme est un logiciel libre : vous pouvez le redistribuer et/ou le
// modifier selon les termes de la GNU General Public License v3.0 (ou
// ultérieure) publiée par la Free Software Foundation. Voir LICENSE.

// Empêche l'ouverture d'une console Windows en mode release.
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;
use tauri_plugin_dialog::DialogExt;
use tauri_plugin_opener::OpenerExt;

/// Enregistre un export (CSV, PNG, sauvegarde JSON) choisi dans l'application.
/// Une boîte « Enregistrer sous » native est proposée ; renvoie `false` si
/// l'utilisateur annule.
#[tauri::command]
fn imbrik_save_export(
    app: tauri::AppHandle,
    name: String,
    data: Vec<u8>,
) -> Result<bool, String> {
    // évite toute écriture hors du nom de fichier prévu par l'application
    let nom = std::path::Path::new(&name)
        .file_name()
        .and_then(|s| s.to_str())
        .unwrap_or("imbrik-export")
        .to_string();

    let cible = app
        .dialog()
        .file()
        .set_title("Enregistrer sous")
        .set_file_name(&nom)
        .blocking_save_file();

    match cible {
        Some(chemin) => {
            let chemin = chemin.into_path().map_err(|e| e.to_string())?;
            std::fs::write(&chemin, data).map_err(|e| e.to_string())?;
            Ok(true)
        }
        None => Ok(false),
    }
}

/// Ouvre une copie imprimable du document dans le navigateur par défaut, qui
/// affiche la boîte de dialogue d'impression (la webview n'implémente pas
/// `window.print()`).
#[tauri::command]
fn imbrik_print_html(app: tauri::AppHandle, html: String) -> Result<(), String> {
    let dossier = app.path().temp_dir().map_err(|e| e.to_string())?;
    let fichier = dossier.join("imbrik-impression.html");
    std::fs::write(&fichier, html).map_err(|e| e.to_string())?;
    app.opener()
        .open_path(fichier.to_string_lossy().to_string(), None::<&str>)
        .map_err(|e| e.to_string())
}

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            imbrik_save_export,
            imbrik_print_html
        ])
        .run(tauri::generate_context!())
        .expect("Erreur au lancement d'Imbrik");
}
