# Imbrik

**Imbrik** est un optimiseur de découpe de panneaux (*panel cutting optimizer*). À partir d'une liste de pièces à produire et des panneaux disponibles, il calcule automatiquement un plan de découpe qui minimise les chutes et le nombre de panneaux utilisés.

## Fonctionnalités

- Saisie des dimensions des panneaux (ex. plaques de bois, verre, métal, etc.)
- Saisie de la liste des pièces à découper, avec quantités
- Calcul d'un plan de découpe optimisé (découpe guillotine / nesting 2D)
- Visualisation du placement des pièces sur chaque panneau
- Minimisation des chutes et du gaspillage de matière
- Export du plan de découpe

## Téléchargement

La version 1.4.2 est disponible dans les [releases](https://github.com/GitKernelDesign/Imbrik/releases) :

| Fichier | Plateforme | Description |
|---|---|---|
| `Imbrik-1.4.2-x64-setup.exe` | Windows 64 bits | Installateur |
| `Imbrik-1.4.2-x64-portable.exe` | Windows 64 bits | Version portable (sans installation) |
| `Imbrik-1.4.2-x86_64.AppImage` | Linux 64 bits | AppImage universel |

## Utilisation

1. Téléchargez la version correspondant à votre système dans les releases.
2. Lancez l'application.
3. Renseignez la taille de vos panneaux et la liste des pièces à découper.
4. Lancez l'optimisation : Imbrik génère le plan de découpe avec le placement de chaque pièce.

## Licence

Imbrik est distribué sous licence **GNU Affero General Public License v3.0 (AGPLv3)**. Voir le fichier [LICENSE](LICENSE) pour le texte complet.
