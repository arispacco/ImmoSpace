# CI issue history

## Manual baseline
- Fixed Dart import paths from feature pages to `lib/core`.
- Updated Flutter API usage for `CardThemeData`, invalid color constants, and `Container.decoration`.
- Updated AR plugin API usage for `config_planedetection.dart`, `ARPlaneAnchor(transformation: ...)`, and `ARNode.eulerAngles`.
- Replaced missing local GLB asset references with remote public GLB URLs.
- Locked Flutter in CI to `3.44.1` and runner images to `ubuntu-24.04` / `macos-15`.
- Patched Android plugin Gradle files for Kotlin/Java JVM target mismatches.
- Patched legacy Android support-library conflicts by excluding `com.android.support`.
- Patched `permission_handler_android` Flutter v1 embedding references pulled by old transitive dependencies.

## 2026-06-10 07:34:15 UTC - run 10
- Commit: e5d48b658d5854d7806e93ff681ba6e44866a776
- Analyze: failure, exit 1
- Android: failure, exit 1
- iOS: success, exit 0
- Main report: ci_reports/latest.md
- Android probable causes:
  - No known pattern detected yet. Inspect the key log lines below.
