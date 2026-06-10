# CI Diagnostic Report

- Workflow: Flutter CI/CD Build
- Run: 11 (27261675356)
- Branch: main
- Commit: f2f69c5a1db02fd8372a1dc95ef5bdbb074c0827
- Generated: 2026-06-10 07:58:19 UTC
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
- Android manifest merger failed. Check ARCore/Sceneform manifest attributes, permissions, features, or meta-data conflicts.
- ARCore/Sceneform manifest entries are involved in the failure.

### Key log lines
```text
32-"Install CMake 3.22.1 v.3.22.1" finished.
33-Font asset "CupertinoIcons.ttf" was tree-shaken, reducing it from 257628 to 848 bytes (99.7% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
34-Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 5156 bytes (99.7% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
35:[com.google.ar.sceneform:core:1.17.1] /home/runner/.gradle/caches/9.1.0/transforms/daf4c7b37a8d704522ad11964c4136e1/transformed/core-1.17.1/AndroidManifest.xml Error:
36:	Namespace 'com.google.ar.sceneform' is used in multiple modules and/or libraries: com.google.ar.sceneform:core:1.17.1, com.google.ar.sceneform:sceneform-base:1.17.1. Please ensure that all modules and libraries have a unique namespace. For more information, See https://developer.android.com/studio/build/configure-app-module#set-namespace
37:/home/runner/work/ImmoSpace/ImmoSpace/android/app/src/main/AndroidManifest.xml Error:
38-	Validation failed, exiting
39-
40:FAILURE: Build failed with an exception.
41-
42:* What went wrong:
43:Execution failed for task ':app:processReleaseMainManifest'.
44:> Manifest merger failed with multiple errors, see logs
45-
46-* Try:
47-> Run with --stacktrace option to get the stack trace.
48-> Run with --info or --debug option to get more log output.
49-> Run with --scan to generate a Build Scan (Powered by Develocity).
50-> Get more help at https://help.gradle.org.
51-
52:BUILD FAILED in 3m 30s
53-Running Gradle task 'assembleRelease'...                          211.3s
54-Gradle task assembleRelease failed with exit code 1
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

