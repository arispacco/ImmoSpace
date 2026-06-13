# ImmoSpace Firebase BaaS

This project uses Firebase as the backend-as-a-service for catalog and VR tour
content, with local fallback data so the app remains usable when Firebase is not
configured yet.

## Firebase products

- Firebase Core: app bootstrap.
- Cloud Firestore: furniture catalog and VR room metadata.
- Firebase Authentication: anonymous session before Firestore reads.
- Firebase Storage: optional host for `.glb` furniture assets and 360 images.

## Runtime configuration

Preferred path after generating native platforms:

```bash
flutter create --org com.immospace --project-name immospace --platforms android,ios .
flutterfire configure --project <firebase-project-id> --platforms android,ios
```

The app also supports runtime `--dart-define` configuration, useful for CI or
for keeping native Firebase config files out of the repository:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=<api-key> \
  --dart-define=FIREBASE_APP_ID=<app-id> \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=<sender-id> \
  --dart-define=FIREBASE_PROJECT_ID=<project-id> \
  --dart-define=FIREBASE_STORAGE_BUCKET=<bucket-name>
```

If Firebase initialization fails, repositories automatically use local fallback
data from their local datasources.

Use [firebase_seed.sample.json](firebase_seed.sample.json) as the baseline
content shape for the first Firestore import or manual console entry.

## Firestore collections

### `furniture`

Each document represents one item available in the dashboard and AR placement.
Use the document id as the stable item id.

```json
{
  "name": "Modern Sofa",
  "category": "Living Room",
  "glbPath": "https://storage.googleapis.com/<bucket>/models/modern-sofa.glb",
  "isActive": true,
  "sortOrder": 10
}
```

Fields:

- `name` string, required.
- `category` string, required.
- `glbPath` string, required. Use an HTTPS URL or a Storage download URL.
- `isActive` boolean, optional. Documents with `false` are hidden.
- `sortOrder` number, optional. Lower values appear first.

### `vrRooms`

Each document represents one 360 room scene. Use the document id as the stable
room id referenced by hotspots.

```json
{
  "name": "Elegant Living Room",
  "imagePath": "https://storage.googleapis.com/<bucket>/vr/living-room-360.jpg",
  "isInitial": true,
  "hotspots": [
    {
      "id": "to_kitchen",
      "targetRoomId": "kitchen",
      "latitude": 45,
      "longitude": 0,
      "label": "Go to Kitchen"
    }
  ]
}
```

Fields:

- `name` string, required.
- `imagePath` string, required. Supports local asset paths and HTTPS URLs.
- `isInitial` boolean, optional. The first matching room starts the tour.
- `hotspots` array, optional.
- `hotspots[].id` string, required.
- `hotspots[].targetRoomId` string, required.
- `hotspots[].latitude` number, required.
- `hotspots[].longitude` number, required.
- `hotspots[].label` string, required.

## Suggested Firestore rules

For a read-only public catalog with anonymous auth enabled:

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /furniture/{document} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    match /vrRooms/{document} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

Use the Firebase Console, Admin SDK, or a trusted back-office app for content
writes.
