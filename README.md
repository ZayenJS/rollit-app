# Rollit – Jeu de soirée mobile

Rollit est une application mobile simple et fun destinée à dynamiser les soirées entre amis.
L’utilisateur lance deux dés virtuels qui génèrent une combinaison _Catégorie + Action_.
Une carte s’affiche alors avec une consigne amusante à réaliser.

La V1 est conçue pour être rapide à développer, intuitive et pensée comme base pour les futures versions (dont le Mode Couple).

---

## ✨ Fonctionnalités principales

-   Lancer deux dés virtuels avec animation.
-   Affichage d’une carte contenant :
    -   icône de catégorie
    -   nom de la catégorie
    -   action correspondante
-   Menu complet :
    -   Packs premium
    -   Suppression des pubs
    -   Paramètres (sons, vibrations, langue)
    -   À propos
-   Gestion des données via JSON local.
-   Publicités via AdMob.
-   Achats intégrés (Google Play Billing).

---

## 🧩 Architecture du projet

```
assets/
  images/
lib/
  main.dart
  models/
      category.dart
      action.dart
  screens/
      home_screen.dart
      result_screen.dart
      settings_screen.dart
      store_screen.dart
  widgets/
      dice_widget.dart
      action_card.dart
  services/
      ads_service.dart
      purchase_service.dart
      random_service.dart
      data_service.dart
  data/
      categories.json
      actions.json
```

---

## 🔧 Installation & lancement

### 1. Cloner le projet

```bash
git clone https://github.com/username/rollit.git
cd rollit

```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer l’application

```bash
flutter run
```

### 4. Build

```bash
flutter build appbundle
```

---

🚀 Roadmap rapide

-   V1 : Lancer des dés, actions aléatoires, boutique + pubs.
-   V1.5 : Packs saisonniers, plus de contenu.
-   V2 : Mode Couple (Romantique, Intimité+).
-   V3 : Backend pour packs dynamiques.

📜 Licence

MIT License

👤 Auteur

Développement & Design : David
