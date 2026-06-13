# 🚀 ImmoSpace - Guide de Configuration Production Étape par Étape

Ce guide vous accompagne pas à pas pour les étapes indispensables que vous devez effectuer **vous-même** sur votre environnement ou sur la console Firebase afin de passer l'application en mode production réelle (sans simulation).

---

## 📋 Table des matières
1. [Envoi du code sur GitHub](#1-envoi-du-code-sur-github)
2. [Génération et Configuration des Dossiers Natifs](#2-génération-et-configuration-des-dossiers-natifs)
3. [Configuration de la base de données Firebase (BaaS)](#3-configuration-de-la-base-de-données-firebase-baas)
4. [Intégration de vos propres Modèles 3D et Photos 360](#4-intégration-de-vos-propres-modèles-3d-et-photos-360)
5. [Compilation et Tests sur Appareil Réel](#5-compilation-et-tests-sur-appareil-réel)

---

## 1. Envoi du code sur GitHub

Toutes les modifications ont été enregistrées localement dans Git. Pour déclencher la compilation automatique (CI/CD) et mettre à jour votre dépôt distant :

1. Ouvrez un terminal sur votre machine dans le dossier du projet.
2. Exécutez la commande suivante :
   ```bash
   cd "/home/Aristide/Projects/Immospace"
   git push origin main
   ```
3. Rendez-vous sur l'onglet **Actions** de votre dépôt GitHub pour suivre la compilation de l'APK (Android) et de l'IPA (iOS).

---

## 2. Génération et Configuration des Dossiers Natifs

*Note : Les dossiers natifs `android/` et `ios/` sont ignorés sous Git pour garder le code propre et portable. Si vous développez localement avec le SDK Flutter, vous devez les configurer.*

### Étape 2.1 : Génération des dossiers
Exécutez cette commande dans le dossier du projet pour recréer les enveloppes mobiles :
```bash
flutter create --org com.immospace --project-name immospace --platforms android,ios .
```

### Étape 2.2 : Application des permissions automatiques
Nous avons créé un script Python `scripts/patch_platforms.py` qui applique automatiquement les configurations complexes (Gradle, Java 11, exclusions Sceneform, permissions). Pour l'exécuter localement :
```bash
python3 scripts/patch_platforms.py
```

### Étape 2.3 : Vérification manuelle (Sécurité)
* **Android (`android/app/src/main/AndroidManifest.xml`)** :
  Vérifiez que la permission caméra et la déclaration ARCore sont bien présentes sous la balise `<manifest>` :
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-feature android:name="android.hardware.camera.ar" android:required="false" />
  ```
  Et dans la balise `<application>` :
  ```xml
  <meta-data android:name="com.google.ar.core" android:value="optional" />
  ```
* **iOS (`ios/Runner/Info.plist`)** :
  Vérifiez la description de la caméra :
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>ImmoSpace nécessite l'accès à la caméra pour scanner le sol et projeter les modèles 3D.</string>
  <key>UIRequiredDeviceCapabilities</key>
  <array>
      <string>armv7</string>
      <string>arkit</string>
  </array>
  ```
* **iOS (`ios/Podfile`)** :
  Assurez-vous que la version plateforme est décommentée et configurée à minimum iOS 11.0 :
  ```ruby
  platform :ios, '11.0'
  ```

---

## 3. Configuration de la base de données Firebase (BaaS)

L'application lit son catalogue et sa visite virtuelle en temps réel sur Firebase Firestore, avec une sécurité d'accès.

### Étape 3.1 : Initialisation de Firebase dans Flutter
1. Installez et lancez l'outil de configuration Firebase CLI :
   ```bash
   flutterfire configure --project=<VOTRE-PROJECT-ID-FIREBASE> --platforms=android,ios
   ```
   *Cela va générer le fichier `lib/firebase_options.dart` nécessaire pour initialiser Firebase au démarrage.*

### Étape 3.2 : Activer l'Authentification Anonyme
Le service de sécurité Firestore exige que l'utilisateur soit connecté (même de manière anonyme) pour lire les données :
1. Allez sur la **Console Firebase** > **Authentication** > **Sign-in method**.
2. Activez le fournisseur **Anonyme** (Anonymous).

### Étape 3.3 : Créer la base de données Cloud Firestore
1. Allez sur **Firestore Database** > **Créer une base de données**.
2. Choisissez le mode de sécurité (Débuter en mode test ou production).
3. Onglet **Règles (Rules)** : Copiez et publiez les règles sécurisées suivantes :
   ```text
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /furniture/{document} {
         allow read: if request.auth != null;
         allow write: if false; // Seul l'administrateur écrit via la console
       }
       match /vrRooms/{document} {
         allow read: if request.auth != null;
         allow write: if false;
       }
     }
   }
   ```

### Étape 3.4 : Importer les données de démonstration (Seed)
Créez les documents dans Cloud Firestore en suivant le schéma structuré fourni dans [docs/firebase_seed.sample.json](file:///home/Aristide/Projects/Immospace/docs/firebase_seed.sample.json) :
1. Créez une collection nommée **`furniture`**.
2. Créez des documents (IDs : 1, 2, 3...) contenant les champs : `name` (String), `category` (String), `glbPath` (String), `isActive` (Boolean), `sortOrder` (Number).
3. Créez une collection nommée **`vrRooms`**.
4. Créez les documents pour chaque pièce (ex: `living_room`, `kitchen`, `balcony`) contenant : `name` (String), `imagePath` (String), `isInitial` (Boolean), et un tableau de cartes `hotspots` pour lier les portes.

---

## 4. Intégration de vos propres Modèles 3D et Photos 360

### Étape 4.1 : Obtenir des meubles 3D réalistes et légers
1. Téléchargez des fichiers **`.glb`** de meubles optimisés depuis des sites comme [poly.pizza](https://poly.pizza/) ou [Sketchfab](https://sketchfab.com/).
2. **Optimisation cruciale** : Pour éviter les ralentissements ou les crashs mémoire sur mobile, chaque meuble doit faire **moins de 5 Mo** et avoir un faible nombre de polygones (*Low Poly*).
3. Téléversez ces fichiers dans l'onglet **Storage** de votre console Firebase.
4. Récupérez les "URLs d'accès" HTTPS et mettez à jour le champ `glbPath` correspondant dans votre base Firestore.

### Étape 4.2 : Vos photos 360° pour la VR
1. Utilisez votre smartphone (mode Photosphère/Panoramique 360° de l'application Google Camera sur Pixel) pour prendre des photos équirectangulaires de vos pièces.
2. Uploadez ces photos 360° (fichiers `.jpg`) sur votre Firebase Storage (ou utilisez le bouton **"Add Room"** directement dans la barre d'action de l'application pour les importer localement depuis votre galerie).

---

## 5. Compilation et Tests sur Appareil Réel

> [!WARNING]
> **Important** : L'AR et la VR nécessitent d'accéder aux capteurs physiques (caméra, gyroscope). Vous **ne pouvez pas** tester ces fonctionnalités sur un émulateur d'ordinateur (qui renverra un écran noir ou une erreur de capteur).

### Option A : Utilisation de la compilation automatisée GitHub (Recommandée)
1. Poussez votre code sur GitHub (`git push origin main`).
2. Attendez la fin de l'Action.
3. Téléchargez le fichier **`immospace-android-release-apk`** depuis les artefacts de build de GitHub.
4. Transférez le fichier `.apk` sur votre téléphone Android et installez-le.

### Option B : Lancement local via câble USB
1. Activez le **Débogage USB** sur votre smartphone de test dans les options développeurs.
2. Branchez le téléphone à votre ordinateur.
3. Exécutez :
   ```bash
   flutter run --release
   ```
