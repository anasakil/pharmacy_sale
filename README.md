# L9a Pharmacy - Application de Localisation des Pharmacies

## Description

L'application **L9a Pharmacy** permet aux utilisateurs de localiser des pharmacies autour d'eux en utilisant une carte interactive Mapbox. En cliquant sur un marqueur représentant une pharmacie, l'utilisateur peut obtenir des informations détaillées, comme le nom, la description, et les coordonnées de l'emplacement. De plus, l'application permet de rediriger l'utilisateur vers Apple Maps ou Waze pour la navigation vers la pharmacie.

### Fonctionnalités principales :
- **Carte interactive avec Mapbox** : Visualiser une carte avec plusieurs pharmacies ajoutées comme marqueurs.
- **Interaction avec les marqueurs** : Cliquer sur un marqueur pour afficher les informations de la pharmacie (nom, description, coordonnées).
- **Redirection vers Apple Maps et Waze** : Obtenir l'itinéraire vers la pharmacie sélectionnée dans Apple Maps ou Waze.
- **Permissions de localisation** : Demander l'autorisation d'accès à la localisation de l'utilisateur pour centrer la carte sur sa position.

## Prérequis

- Flutter 3.0 ou version supérieure
- Compte Mapbox pour obtenir une clé d'accès à l'API
- Autorisations pour accéder à la localisation de l'utilisateur

## Installation

1. Clonez le repository :
   git clone https://github.com/anasakil/pharmacy_sale.git
2. Naviguez dans le répertoire du projet :
   cd pharmacy_sale
3. Installez les dépendances Flutter :
   flutter pub get
   Remplacez YOUR_MAPBOX_ACCESS_TOKEN dans le fichier lib/utils/tokenmapbox.dart par votre propre clé API Mapbox.



4. Utilisation
   Lancez l'application :
   flutter run
   Sur la carte, vous verrez plusieurs pharmacies indiquées par des marqueurs. Cliquez sur un marqueur pour voir les détails de la pharmacie et choisissez l'option de navigation souhaitée (Apple Maps ou Waze).

## Démonstration Vidéo
Voici une vidéo démonstrative de l'application en action :
[Regarder la vidéo] (assets/rec.mp4)




## Structure du projet
La structure du projet est la suivante :


- **`components/`** : Contient les composants réutilisables comme la barre de navigation (`CustomDrawer.dart`) et l'écran d'accueil (`SplashScreen.dart`).
- **`models/`** : Contient le modèle de données pour les pharmacies, avec des informations comme le nom, la localisation, et les coordonnées (`pharmacy_model.dart`).
- **`pages/`** : Contient les différentes pages de l'application comme la page "À propos", la FAQ, la liste des pharmacies, et la carte interactive avec les pharmacies.
- **`utils/`** : Contient des fichiers utilitaires, notamment `tokenmapbox.dart` pour la gestion de la clé API Mapbox.
- **`viewmodels/`** : Contient la logique de gestion des pharmacies (`pharmacy_viewmodel.dart`), responsable de la récupération des données et de l'affichage.
- **`main.dart`** : Point d'entrée de l'application Flutter.
- **`pharmacy_list_screen.dart`** : Écran qui affiche la liste des pharmacies.
- **`pharmacy_map_screen.dart`** : Écran qui affiche la carte interactive avec les pharmacies.

Cette structure permet de bien organiser le code en séparant les composants réutilisables, les pages, et la logique métier de manière claire et maintenable.


