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

## 🚀 4. CI/CD Compilation (GitHub Actions)

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
