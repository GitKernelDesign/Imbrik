# Imbrik

**Imbrik** est un optimiseur de découpe de panneaux (*panel cutting optimizer*). À partir d'une liste de pièces à produire et des panneaux disponibles, il calcule automatiquement un plan de découpe qui minimise les chutes et le nombre de panneaux utilisés.

## Fonctionnalités

- Saisie des dimensions des panneaux (ex. plaques de bois, verre, métal, etc.)
- Saisie de la liste des pièces à découper, avec quantités
- Calcul d'un plan de découpe optimisé, **guillotine** : toutes les coupes traversent la pièce en cours de découpe, donc le plan est exécutable à la scie à format
- Visualisation du placement des pièces sur chaque panneau, avec le sens du fil du bois
- Minimisation des chutes et du gaspillage de matière
- Export du plan de découpe (CSV, PNG, impression / PDF)
- **Étiquettes d'identification** pour les pièces découpées et les chutes : 105 × 57 mm, 10 par feuille A4

### Nouveautés de la version 1.5.0

- **Critère d'optimisation au choix** : « Moins de panneaux » (moins de plaques entamées) ou « Moins de matière » (surface consommée minimale quand plusieurs formats sont en stock).
- **Remplissage à deux niveaux** : la colonne de droite et le bandeau du bas d'un panneau sont réutilisés par le même principe de bandes, au lieu d'être laissés en chute.
- **Épaisseur et matière** par panneau et par pièce : une pièce ne peut plus être placée sur un panneau d'une autre épaisseur ou d'une autre matière.
- **Marge de rabotage** : retrait d'une bande sur les quatre bords du panneau (délignage, équerrage) avant placement.
- **Chutes réutilisables** : un bouton ajoute les chutes du plan au stock pour la découpe suivante.
- **Impression d'étiquettes** (menu ☰ → Étiquettes) : planche de 10 étiquettes 105 × 57 mm par feuille A4, avec nom, dimensions, numéro et matière. Un menu permet de saisir le nom de la commande ou du client (reporté sur chaque étiquette) et de choisir les éléments (pièces, chutes ou les deux), le contenu et la mise en page.
- **Sauvegarde automatique** de l'état courant : un rafraîchissement ne perd plus le travail en cours.
- **Boîtes de dialogue intégrées** à la place des fenêtres natives du navigateur.
- Champs étiquetés pour les lecteurs d'écran, export CSV correctement échappé.

## Code source

L'application est un fichier HTML autonome, 100 % local (aucune donnée envoyée) : [`Imbrik-v1.5.0.html`](Imbrik-v1.5.0.html). Ouvrez-le directement dans un navigateur pour l'utiliser.

## Téléchargement

> **Note** : les exécutables publiés ci-dessous ont été construits à partir de la version **1.4.2**. Le code source du dépôt est en **1.5.0** ; les applications packagées seront régénérées à la prochaine publication. En attendant, la version 1.5.0 s'utilise en ouvrant le fichier HTML dans un navigateur.

La version 1.4.2 est disponible dans les [releases](https://github.com/GitKernelDesign/Imbrik/releases) :

| Fichier | Plateforme | Description |
|---|---|---|
| `Imbrik-1.4.2-x64-setup.exe` | Windows 64 bits | Installateur |
| `Imbrik-1.4.2-x64-portable.exe` | Windows 64 bits | Version portable (sans installation) |
| `Imbrik-1.4.2-x86_64.AppImage` | Linux 64 bits | AppImage universel |

## Utilisation

1. Téléchargez la version correspondant à votre système dans les releases, ou ouvrez `Imbrik-v1.5.0.html` dans un navigateur.
2. Renseignez la taille de vos panneaux et la liste des pièces à découper.
3. Choisissez le critère d'optimisation et, si besoin, la largeur de coupe et la marge de rabotage.
4. Le plan se recalcule automatiquement ; le bouton « Calculer » reste disponible.
5. Exportez le plan en CSV, PNG ou imprimez-le.
6. Pour identifier les pièces à l'atelier : menu ☰ → **Étiquettes**. À l'impression, choisissez des marges « aucune » et une échelle de 100 % pour respecter le format 105 × 57 mm.

## Licence

Imbrik est distribué sous licence **GNU General Public License v3.0 (GPLv3)**. Voir le fichier [LICENSE](LICENSE) pour le texte complet.
