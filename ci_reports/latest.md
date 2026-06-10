# CI Diagnostic Report

- Workflow: Flutter CI/CD Build
- Run: 10 (27260381814)
- Branch: main
- Commit: e5d48b658d5854d7806e93ff681ba6e44866a776
- Generated: 2026-06-10 07:34:15 UTC
- Flutter: 3.44.1

## Flutter analyze
- Job result: failure
- Command exit code: 1

### Probable causes
- No known pattern detected yet. Inspect the key log lines below.

### Key log lines
```text
```

### Last 300 log lines
See ci_reports/logs/flutter_analyze_tail.log after pulling the report commit.

## Android release APK
- Job result: failure
- Command exit code: 1

### Probable causes
- No known pattern detected yet. Inspect the key log lines below.

### Key log lines
```text
35:[com.google.ar.sceneform:core:1.17.1] /home/runner/.gradle/caches/9.1.0/transforms/daf4c7b37a8d704522ad11964c4136e1/transformed/core-1.17.1/AndroidManifest.xml Error:
37:/home/runner/work/ImmoSpace/ImmoSpace/android/app/src/main/AndroidManifest.xml Error:
40:FAILURE: Build failed with an exception.
42:* What went wrong:
43:Execution failed for task ':app:processReleaseMainManifest'.
52:BUILD FAILED in 4m 1s
```

### Last 300 log lines
See ci_reports/logs/android_build_tail.log after pulling the report commit.

## iOS unsigned build
- Job result: success
- Command exit code: 0

### Probable causes
- No known pattern detected yet. Inspect the key log lines below.

### Key log lines
```text
```

### Last 300 log lines
See ci_reports/logs/ios_build_tail.log after pulling the report commit.

