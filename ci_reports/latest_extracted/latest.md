# CI Diagnostic Report

- Workflow: Flutter CI/CD Build
- Run: 23 (27700561197)
- Branch: main
- Commit: 58b0a3f4cb5c065b69c654c5381d73aeb6bb6fc9
- Generated: 2026-06-17 15:37:42 UTC
- Flutter: 3.44.1

## Flutter analyze
- Job result: failure
- Command exit code: unknown

### Probable causes
- Flutter analyze reported Dart analyzer diagnostics.

### Key log lines
```text
1-Analyzing ImmoSpace...                                          
2-
3:   info • 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round().clamp(0, 255). Try replacing the use of the deprecated member with the replacement • lib/core/presentation/widgets/glass_container.dart:49:43 • deprecated_member_use
4:   info • 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round().clamp(0, 255). Try replacing the use of the deprecated member with the replacement • lib/core/presentation/widgets/glass_container.dart:49:54 • deprecated_member_use
5:   info • 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round().clamp(0, 255). Try replacing the use of the deprecated member with the replacement • lib/core/presentation/widgets/glass_container.dart:49:67 • deprecated_member_use
6:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:34:34 • deprecated_member_use
7:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:60:50 • deprecated_member_use
8:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:65:52 • deprecated_member_use
9:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:79:54 • deprecated_member_use
10:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:116:43 • deprecated_member_use
11:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:145:43 • deprecated_member_use
12:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:147:62 • deprecated_member_use
13:   info • Use interpolation to compose strings and values. Try using string interpolation to build the composite string • lib/core/utils/integrity_verifier.dart:153:57 • prefer_interpolation_to_compose_strings
14:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:167:66 • deprecated_member_use
15:warning • The value of the field '_cameraPermissionGranted' isn't used. Try removing the field, or using it • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:50:8 • unused_field
16:warning • The value of the field '_checkingPermission' isn't used. Try removing the field, or using it • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:51:8 • unused_field
17:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:337:54 • deprecated_member_use
18:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:339:56 • deprecated_member_use
19:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:344:58 • deprecated_member_use
20:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:366:54 • deprecated_member_use
21:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:409:50 • deprecated_member_use
22:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:422:50 • deprecated_member_use
23:   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext use with a 'mounted' check on the BuildContext • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:433:44 • use_build_context_synchronously
24:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:489:55 • deprecated_member_use
25:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:489:98 • deprecated_member_use
26:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:523:26 • deprecated_member_use
27:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:537:33 • deprecated_member_use
28:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:575:50 • deprecated_member_use
29:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:664:50 • deprecated_member_use
30:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:687:55 • deprecated_member_use
31:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:708:58 • deprecated_member_use
32:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:710:77 • deprecated_member_use
33:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:769:51 • deprecated_member_use
34:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:772:57 • deprecated_member_use
35:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:778:52 • deprecated_member_use
36:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:66:42 • deprecated_member_use
37:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:72:46 • deprecated_member_use
38:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:102:28 • deprecated_member_use
39:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:107:28 • deprecated_member_use
40:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:141:22 • deprecated_member_use
41:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:142:22 • deprecated_member_use
42:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:174:28 • deprecated_member_use
43:   info • Use 'const' for final variables initialized to a constant value. Try replacing 'final' with 'const' • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:178:5 • prefer_const_declarations
44:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:149:54 • deprecated_member_use
45:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:174:33 • deprecated_member_use
46:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:177:35 • deprecated_member_use
47:   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • lib/features/dashboard/presentation/pages/dashboard_page.dart:184:25 • prefer_const_constructors
48:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:249:41 • deprecated_member_use
49:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:271:43 • deprecated_member_use
50:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:292:45 • deprecated_member_use
51:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:397:33 • deprecated_member_use
52:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:402:35 • deprecated_member_use
53:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:422:47 • deprecated_member_use
54:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:476:41 • deprecated_member_use
55:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:507:37 • deprecated_member_use
56:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:148:35 • deprecated_member_use
57:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:151:39 • deprecated_member_use
58:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:201:39 • deprecated_member_use
59:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:203:41 • deprecated_member_use
60:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:210:39 • deprecated_member_use
61:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:264:41 • deprecated_member_use
62:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:334:44 • deprecated_member_use
63:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:362:37 • deprecated_member_use
64:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:383:54 • deprecated_member_use
65:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:418:31 • deprecated_member_use
66:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:102:41 • deprecated_member_use
67:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:243:50 • deprecated_member_use
68:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:261:54 • deprecated_member_use
69:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:290:50 • deprecated_member_use
70:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:319:50 • deprecated_member_use
71:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:388:49 • deprecated_member_use
72:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:390:55 • deprecated_member_use
73:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:396:49 • deprecated_member_use
74:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:410:50 • deprecated_member_use
75:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:410:82 • deprecated_member_use
76:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:463:50 • deprecated_member_use
77:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:553:59 • deprecated_member_use
78:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:581:41 • deprecated_member_use
79:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:583:60 • deprecated_member_use
80:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:698:35 • deprecated_member_use
81:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:698:61 • deprecated_member_use
82:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:701:45 • deprecated_member_use
83:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:705:41 • deprecated_member_use
84:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:731:59 • deprecated_member_use
85:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:731:92 • deprecated_member_use
86:   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext use with a 'mounted' check on the BuildContext • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:769:7 • use_build_context_synchronously
87:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:786:69 • deprecated_member_use
88:   info • Unnecessary braces in a string interpolation. Try removing the braces • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:829:21 • unnecessary_brace_in_string_interps
89:   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext use with a 'mounted' check on the BuildContext • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:839:7 • use_build_context_synchronously
90:   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext use with a 'mounted' check on the BuildContext • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:840:28 • use_build_context_synchronously
91:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:59:58 • deprecated_member_use
92:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:77:58 • deprecated_member_use
93:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:97:56 • deprecated_member_use
94:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:120:33 • deprecated_member_use
95:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:123:46 • deprecated_member_use
96:   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • test/features/ar_placement/presentation/bloc/ar_placement_bloc_test.dart:37:31 • prefer_const_constructors
97:   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • test/features/ar_placement/presentation/bloc/ar_placement_bloc_test.dart:72:31 • prefer_const_constructors
98:   info • Use 'const' for final variables initialized to a constant value. Try replacing 'final' with 'const' • test/features/vr_tour/presentation/bloc/vr_tour_bloc_test.dart:34:3 • prefer_const_declarations
99:   info • Use 'const' for final variables initialized to a constant value. Try replacing 'final' with 'const' • test/features/vr_tour/presentation/bloc/vr_tour_bloc_test.dart:41:3 • prefer_const_declarations
100:  error • The name 'MyApp' isn't a class. Try correcting the name to match an existing class • test/widget_test.dart:16:35 • creation_with_non_type
101-
102-98 issues found. (ran in 8.6s)
```

### Last 300 log lines
See ci_reports/logs/flutter_analyze_tail.log after pulling the report commit.

## Android release APK
- Job result: failure
- Command exit code: unknown

### Probable causes
- Android manifest merger failed. Check ARCore/Sceneform manifest attributes, permissions, features, or meta-data conflicts.
- Android dependencies contain duplicate namespaces; usually an obsolete native library is incompatible with the current Android Gradle Plugin.
- ARCore/Sceneform manifest entries are involved in the failure.

### Key log lines
```text
28-Note: Recompile with -Xlint:unchecked for details.
29-Note: Some input files use or override a deprecated API.
30-Note: Recompile with -Xlint:deprecation for details.
31:[com.google.ar.sceneform:core:1.15.0] /home/runner/.gradle/caches/9.1.0/transforms/9c925a117623be66454388df13aa733e/transformed/core-1.15.0/AndroidManifest.xml Error:
32:	Namespace 'com.google.ar.sceneform' is used in multiple modules and/or libraries: com.google.ar.sceneform:core:1.15.0, com.google.ar.sceneform:sceneform-base:1.15.0. Please ensure that all modules and libraries have a unique namespace. For more information, See https://developer.android.com/studio/build/configure-app-module#set-namespace
33:/home/runner/work/ImmoSpace/ImmoSpace/android/app/src/main/AndroidManifest.xml Error:
34-	Validation failed, exiting
35-
36:FAILURE: Build failed with an exception.
37-
38:* What went wrong:
39:Execution failed for task ':app:processReleaseMainManifest'.
40:> Manifest merger failed with multiple errors, see logs
41-
42-* Try:
43-> Run with --stacktrace option to get the stack trace.
44-> Run with --info or --debug option to get more log output.
45-> Run with --scan to generate a Build Scan (Powered by Develocity).
46-> Get more help at https://help.gradle.org.
47-
48:BUILD FAILED in 4m 2s
49-Running Gradle task 'assembleRelease'...                          243.0s
50-Gradle task assembleRelease failed with exit code 1
```

### Last 300 log lines
See ci_reports/logs/android_build_tail.log after pulling the report commit.

## iOS unsigned build
- Job result: failure
- Command exit code: unknown

### Probable causes
- No known pattern detected yet. Inspect the key log lines below.

### Key log lines
```text
```

### Last 300 log lines
See ci_reports/logs/ios_build_tail.log after pulling the report commit.

