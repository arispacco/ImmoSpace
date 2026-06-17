# Platform Configuration & Deployment Integration Guide

Since platform folders (`android/` and `ios/`) are generated dynamically or kept untracked, this guide provides the exact steps and configuration blocks required to enable native ARCore (Android) and ARKit (iOS) rendering.

---

## 🏗️ 1. Platform Generation

To generate the native platform structures on a machine with the Flutter SDK installed, run:

```bash
# Generate platform runner folders for Android and iOS
flutter create --platforms=android,ios .
```

---

## 🤖 2. Android Configuration (ARCore)

After generating the `android/` directory, update the following files to enable surface tracking permissions:

### File: `android/app/src/main/AndroidManifest.xml`
Add camera permissions and ARCore feature requests under the `<manifest>` tag:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Camera Permission for AR -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- Declare ARCore requirement -->
    <uses-feature android:name="android.hardware.camera.ar" android:required="true" />
    
    <application ...>
        <!-- Metadata to prompt Play Store to install ARCore Services -->
        <meta-data android:name="com.google.ar.core" android:value="required" />
        ...
    </application>
</manifest>
```

### File: `android/app/build.gradle`
Ensure the minimum SDK version is set to at least **24** (required for ARCore):

```groovy
android {
    defaultConfig {
        minSdkVersion 24 // Required for ARCore integration
        targetSdkVersion 33
        ...
    }
}
```

---

## 🍎 3. iOS Configuration (ARKit)

After generating the `ios/` directory, update the configuration keys to request camera access and restrict distribution to ARKit-compatible devices.

### File: `ios/Runner/Info.plist`
Add the following keys inside the `<dict>` tag:

```xml
<dict>
    <!-- Camera Permission Description -->
    <key>NSCameraUsageDescription</key>
    <string>ImmoSpace requires camera access to scan your floor surface and project 3D models in real space.</string>
    
    <!-- ARKit Hardware Requirement -->
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
        <string>arkit</string>
    </array>
    ...
</dict>
```

### File: `ios/Podfile`
Ensure the target platform version is set to **iOS 11.0** (or higher) to support ARKit APIs:

```ruby
platform :ios, '11.0'
```

---

## 🔥 4. Firebase Backend Configuration

The Flutter app now initializes Firebase at startup and reads backend data from Cloud Firestore. If Firebase is not configured yet, the app keeps working with the built-in fallback catalogue and VR rooms.

### FlutterFire dependencies

The backend layer uses:

```yaml
firebase_core: ^4.10.0
cloud_firestore: ^6.5.0
firebase_auth: ^6.5.2
```

After installing Flutter locally or in CI, run:

```bash
flutter pub get
```

### Runtime configuration

You can configure Firebase in either of these ways:

1. Run FlutterFire configuration after platform generation:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This adds the native Firebase files and platform build settings. Mobile builds can then use native Firebase configuration. Web or secret-driven CI builds should use Dart defines.

2. Or pass Firebase options with Dart defines:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=your-api-key \
  --dart-define=FIREBASE_APP_ID=your-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_PROJECT_ID=your-project-id \
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project.appspot.com
```

The same flags can be added to `flutter build apk` or `flutter build ios`.

### Firebase Authentication

Enable **Anonymous Authentication** in Firebase Console. The app signs in anonymously before reading Firestore so private read rules can be enabled later without adding a visible login screen.

### Firestore collections

Create a `furniture` collection. Each document can use the furniture ID as the document ID:

```json
{
  "name": "Modern Sofa",
  "category": "Living Room",
  "glbPath": "https://example.com/models/modern-sofa.glb",
  "isActive": true,
  "sortOrder": 10
}
```

Create a `vrRooms` collection. Use `living_room` as the initial fallback document ID or set `isInitial` to `true` on another room:

```json
{
  "name": "Elegant Living Room",
  "imagePath": "assets/images/living_room_360.jpg",
  "isInitial": true,
  "hotspots": [
    {
      "id": "h1",
      "targetRoomId": "kitchen",
      "latitude": 45.0,
      "longitude": 0.0,
      "label": "Go to Kitchen"
    }
  ]
}
```

### Suggested Firestore rules

Use public reads for the presentation catalogue and restrict writes to accounts with an `admin` custom claim:

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    function isAdmin() {
      return request.auth != null && request.auth.token.admin == true;
    }

    match /furniture/{document} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /vrRooms/{document} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 🚀 5. CI/CD Compilation (GitHub Actions)

Once the platform folders are generated and modified, commit the changes to your remote GitHub repository:

```bash
git add .
git commit -m "feat: configure native platform ARCore and ARKit permissions"
git push origin main
```

The GitHub Actions workflow [.github/workflows/flutter_build.yml](file:///run/media/Aristide/Nouveau nom/Immospace/.github/workflows/flutter_build.yml) will trigger automatically and build the deployable `.apk` and `.ipa` artifacts.

---

## 5. Firebase BaaS

ImmoSpace reads its furniture catalog and VR room metadata from Firebase, with
local fallback data when Firebase is not configured. Configure Firebase after
generating the native platform folders, then follow the collection schema and
rules in [firebase_baas.md](firebase_baas.md).
