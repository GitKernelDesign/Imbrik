Version 1.5.0 d'Imbrik, optimiseur de découpe de panneaux.

## Contenu

- `Imbrik-1.5.0-x64-setup.exe` — installateur Windows 64 bits
- `Imbrik-1.5.0-x64-portable.exe` — version portable Windows 64 bits
- `Imbrik-1.5.0-x86_64.AppImage` — AppImage Linux 64 bits
- `Imbrik-1.5.0-arm64-mac.zip` — application macOS pour Apple Silicon
- `Imbrik-1.5.0-x64-mac.zip` — application macOS pour Mac Intel

> macOS : décompressez l'archive, glissez `Imbrik.app` dans le dossier
> Applications, puis clic droit → **Ouvrir** au premier lancement (paquet signé
> ad hoc, non notarié).

## Nouveautés

- **Critère d'optimisation au choix** : « Moins de panneaux » (moins de plaques entamées) ou « Moins de matière » (surface consommée minimale quand plusieurs formats sont en stock).
- **Remplissage à deux niveaux** : la colonne de droite et le bandeau du bas d'un panneau sont réutilisés par le même principe de bandes, au lieu d'être laissés en chute.
- **Épaisseur et matière** par panneau et par pièce : une pièce ne peut plus être placée sur un panneau d'une autre épaisseur ou d'une autre matière.
- **Marge de rabotage** : retrait d'une bande sur les quatre bords du panneau (délignage, équerrage) avant placement.
- **Chutes réutilisables** : un bouton ajoute les chutes du plan au stock pour la découpe suivante.
- **Impression d'étiquettes** (menu ☰ → Étiquettes) : planche de 10 étiquettes 105 × 57 mm par feuille A4, avec nom, dimensions, numéro et matière, et un champ **commande / client** reporté sur chaque étiquette. Le menu permet de choisir les éléments (pièces, chutes ou les deux), le contenu et la mise en page.
- **Sauvegarde automatique** de l'état courant : un rafraîchissement ne perd plus le travail en cours.
- **Boîtes de dialogue intégrées** à la place des fenêtres natives du navigateur.
- Champs étiquetés pour les lecteurs d'écran, export CSV correctement échappé.

## Correctifs

- Blocages sur les cas limites du moteur de découpe et du rendu du plan.
- Cohérence des chutes : elles proviennent exactement du moteur (`sheet.free`) au lieu d'être recalculées.

## Technique

- Empaquetage **Electron 45** à partir du fichier HTML : l'interface est identique dans le navigateur et dans les applications de bureau.
- Icône d'application dérivée de `icon.svg`.
- Licence **GPLv3** (le projet était en AGPLv3).
- Le fichier `Imbrik-v1.5.0.html` reste utilisable seul : aucune donnée n'est envoyée, tout est local.

## Notes d'installation

- Windows : l'installateur crée les raccourcis menu Démarrer et bureau ; la version portable ne s'installe pas.
- Linux : `chmod +x Imbrik-1.5.0-x86_64.AppImage` puis exécution directe. Si le bac à sable SUID pose problème : `./Imbrik-1.5.0-x86_64.AppImage --no-sandbox`.
- Les binaires ne sont pas signés : un avertissement SmartScreen peut apparaître au premier lancement sous Windows.
