# GitHub Actions CI/CD Build Workflow Plan

We will create a GitHub Actions workflow file to build the ImmoSpace Flutter application. This enables compilation and packaging of Android (`.apk`) and iOS (`.ipa`) applications without needing a local development environment.

## User Review Required

> [!NOTE]
> - **Android Build**: The workflow will produce an unsigned Release APK (`app-release.apk`) which is installable on Android devices for testing (some devices require enabling "Install from Unknown Sources").
> - **iOS Build**: iOS builds require an active Apple Developer Certificate for official signing. To allow building on GitHub Actions without certificate secrets, the workflow will build with `--no-codesign` and package it into an unsigned `.ipa`. This can be signed later or installed on test devices/simulators.
> - **Trigger**: The workflow will trigger on any push to the `main` branch or manually via the GitHub interface (`workflow_dispatch`).

## Proposed Changes

### CI/CD Configuration

#### [NEW] [flutter_build.yml](file:///run/media/Aristide/Nouveau nom/Immospace/.github/workflows/flutter_build.yml)
Defines the GitHub Actions pipeline.

1. **`build-android` Job** (Runs on `ubuntu-latest`):
   - Sets up JDK 17 (required by modern Gradle versions).
   - Sets up Flutter using `subosito/flutter-action` with caching.
   - Restores dependencies and compiles the APK (`flutter build apk --release`).
   - Uploads the resulting `.apk` binary as an artifact.

2. **`build-ios` Job** (Runs on `macos-latest`):
   - Sets up Flutter with caching.
   - Compiles iOS runner with `--no-codesign`.
   - Packages the compiled `Runner.app` into an unsigned `Runner.ipa`.
   - Uploads the resulting `.ipa` binary as an artifact.

---

## Verification Plan

### Automated Checks
- Validate the YAML syntax of the workflow.

### Manual Verification
- Commit the workflow to GitHub and trigger a manual run to verify that both the Android APK and iOS IPA build jobs succeed and attach their artifacts.
