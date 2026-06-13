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
- Switched generated Android ARCore manifest entries to optional (`android.hardware.camera.ar` required=false, `com.google.ar.core` value=optional) to avoid Sceneform manifest merge conflicts while keeping the simulation fallback available.
- Improved CI report extraction so Android manifest merger errors and Flutter analyzer diagnostics include context lines and probable causes.
- Replaced the unmaintained native `ar_flutter_plugin` dependency with a local CI-safe compatibility adapter because Google Sceneform 1.17.1 ships duplicate `com.google.ar.sceneform` namespaces that current Android Gradle Plugin versions reject.
- Allowed committed CI log tails under `ci_reports/logs/*.log`; the global `*.log` ignore rule was blocking them.

## 2026-06-10 07:34:15 UTC - run 10
- Commit: e5d48b658d5854d7806e93ff681ba6e44866a776
- Analyze: failure, exit 1
- Android: failure, exit 1
- iOS: success, exit 0
- Main report: ci_reports/latest.md
- Android probable causes:
  - No known pattern detected yet. Inspect the key log lines below.

## 2026-06-10 07:58:19 UTC - run 11
- Commit: f2f69c5a1db02fd8372a1dc95ef5bdbb074c0827
- Analyze: failure, exit 1
- Android: failure, exit 1
- iOS: success, exit 0
- Main report: ci_reports/latest.md
- Android probable causes:
  - Android manifest merger failed. Check ARCore/Sceneform manifest attributes, permissions, features, or meta-data conflicts.
  - ARCore/Sceneform manifest entries are involved in the failure.

## 2026-06-10 21:52:45 UTC - run 13
- Commit: 8744b754ad85f28b397755b3be4c6391af6421ec
- Analyze: failure, exit 1
- Android: success, exit 0
- iOS: success, exit 0
- Main report: ci_reports/latest.md
- Android probable causes:
  - No known pattern detected yet. Inspect the key log lines below.

## 2026-06-13 08:21:00 UTC - run 14
- Commit: debf4b7f71f035d6713fb0dfb71d75356753ce24
- Analyze: failure, exit unknown
- Android: failure, exit unknown
- iOS: failure, exit unknown
- Main report: ci_reports/latest.md
- Android probable causes:
  - Log missing: the job probably failed before the command was captured.

## 2026-06-13 08:34:39 UTC - run 15
- Commit: a532e8164bc7250205219745401b09ce082492d9
- Analyze: failure, exit unknown
- Android: failure, exit unknown
- iOS: failure, exit unknown
- Main report: ci_reports/latest.md
- Android probable causes:
  - Log missing: the job probably failed before the command was captured.
