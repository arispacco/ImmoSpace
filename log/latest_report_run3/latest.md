# CI Diagnostic Report

- Workflow: Flutter CI/CD Build
- Run: 27 (27713765335)
- Branch: main
- Commit: f5702fee6f2ccfd2d0f04d3012a67f01a714ac3d
- Generated: 2026-06-17 19:28:41 UTC
- Flutter: 3.44.1

## Flutter analyze
- Job result: success
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
96-
97-93 issues found. (ran in 6.5s)
```

### Last 300 log lines
See ci_reports/logs/flutter_analyze_tail.log after pulling the report commit.

## Android release APK
- Job result: failure
- Command exit code: unknown

### Probable causes
- ARCore/Sceneform manifest entries are involved in the failure.

### Key log lines
```text
30-Note: Recompile with -Xlint:deprecation for details.
31-Caught exception: Already watching path: /home/runner/work/ImmoSpace/ImmoSpace/android
32-ERROR: Missing classes detected while running R8. Please add the missing classes or apply additional keep rules that are generated in /home/runner/work/ImmoSpace/ImmoSpace/build/app/outputs/mapping/release/missing_rules.txt.
33:ERROR: R8: Missing class com.google.ar.sceneform.animation.AnimationEngine (referenced from: com.google.ar.sceneform.animation.AnimationEngine com.google.ar.sceneform.SceneView.animationEngine and 2 other contexts)
34:Missing class com.google.ar.sceneform.animation.AnimationLibraryLoader (referenced from: void com.google.ar.sceneform.SceneView.initializeAnimation())
35:Missing class com.google.ar.sceneform.assets.Loader (referenced from: void com.google.ar.sceneform.rendering.EngineInstance.createEngine())
36:Missing class com.google.ar.sceneform.assets.ModelData (referenced from: void com.google.ar.sceneform.rendering.Material.copyMaterialParameters(com.google.ar.sceneform.assets.ModelData, int))
37:Missing class com.google.devtools.build.android.desugar.runtime.ThrowableExtension (referenced from: byte[] com.google.ar.sceneform.utilities.SceneformBufferUtils.inputStreamCallableToByteArray(java.util.concurrent.Callable) and 1 other context)
38-
39:FAILURE: Build completed with 2 failures.
40-
41-1: Task failed with an exception.
42------------
43:* What went wrong:
44:Execution failed for task ':ar_flutter_plugin:checkReleaseAarMetadata'.
45-> A failure occurred while executing com.android.build.gradle.internal.tasks.CheckAarMetadataWorkAction
46-   > 15 issues were found when checking AAR metadata:
47-
48-       1.  Dependency 'androidx.fragment:fragment:1.7.1' requires libraries and applications that
49-           depend on it to compile against version 34 or later of the
50-           Android APIs.
--
279-
280-2: Task failed with an exception.
281------------
282:* What went wrong:
283:Execution failed for task ':app:minifyReleaseWithR8'.
284-> A failure occurred while executing com.android.build.gradle.internal.tasks.R8Task$R8Runnable
285-   > Compilation failed to complete
286-
287-* Try:
288-> Run with --stacktrace option to get the stack trace.
289-> Run with --info or --debug option to get more log output.
--
291-> Get more help at https://help.gradle.org.
292-==============================================================================
293-
294:BUILD FAILED in 4m 12s
295-Running Gradle task 'assembleRelease'...                          252.8s
296-Gradle task assembleRelease failed with exit code 1
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

