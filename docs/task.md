# Checklist for ImmoSpace Flutter Architecture Setup

- [x] Create `pubspec.yaml` with the required dependencies
- [x] Create `main.dart` as the entrypoint
- [x] Create GoRouter routing configuration (`app_router.dart`)
- [x] Implement Feature: Dashboard/Catalogue
    - [x] Create Furniture entity and model
    - [x] Create Dashboard BLoC, events, and states
    - [x] Create Dashboard Page UI (Grid list)
- [x] Implement Feature: VR Tour
    - [x] Create VR Tour BLoC, events, and states
    - [x] Create VR Tour Page UI (Panorama Viewer with hotspots and proper lifecycle disposal)
- [x] Implement Feature: AR Placement
    - [x] Create AR Placement BLoC, events, and states
    - [x] Create AR Placement Page UI (Camera view, surface detection setup, and resource disposal)
- [x] Verify correctness and output setup documentation
- [x] Implement Proprietary Protection & Proof of Authorship
    - [x] Create LICENSE file
    - [x] Implement hidden gesture and tap signature in DashboardPage
- [x] Configure CI/CD GitHub Actions Build Pipeline
    - [x] Create flutter_build.yml workflow file
- [x] Integrate Firebase BaaS
    - [x] Add Firebase backend service with local fallback behavior
    - [x] Document Firestore collections and Firebase setup

