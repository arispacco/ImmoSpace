# CI Diagnostic Report

- Workflow: Flutter CI/CD Build
- Run: 13 (27308488276)
- Branch: main
- Commit: 8744b754ad85f28b397755b3be4c6391af6421ec
- Generated: 2026-06-10 21:52:45 UTC
- Flutter: 3.44.1

## Flutter analyze
- Job result: failure
- Command exit code: 1

### Probable causes
- Flutter analyze reported Dart analyzer diagnostics.

### Key log lines
```text
1-Analyzing ImmoSpace...                                          
2-
3:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/presentation/widgets/glass_container.dart:49:28 • deprecated_member_use
4:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/presentation/widgets/glass_container.dart:53:41 • deprecated_member_use
5:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:34:34 • deprecated_member_use
6:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:60:50 • deprecated_member_use
7:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:65:52 • deprecated_member_use
8:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:79:54 • deprecated_member_use
9:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:116:43 • deprecated_member_use
10:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:145:43 • deprecated_member_use
11:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:147:62 • deprecated_member_use
12:   info • Use interpolation to compose strings and values. Try using string interpolation to build the composite string • lib/core/utils/integrity_verifier.dart:153:57 • prefer_interpolation_to_compose_strings
13:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/core/utils/integrity_verifier.dart:167:66 • deprecated_member_use
14:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:310:54 • deprecated_member_use
15:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:312:56 • deprecated_member_use
16:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:317:58 • deprecated_member_use
17:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:339:54 • deprecated_member_use
18:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:382:50 • deprecated_member_use
19:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:395:50 • deprecated_member_use
20:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:444:55 • deprecated_member_use
21:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:444:98 • deprecated_member_use
22:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:478:26 • deprecated_member_use
23:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:492:33 • deprecated_member_use
24:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:530:50 • deprecated_member_use
25:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:619:50 • deprecated_member_use
26:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:642:55 • deprecated_member_use
27:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:663:58 • deprecated_member_use
28:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:665:77 • deprecated_member_use
29:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:781:51 • deprecated_member_use
30:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:784:57 • deprecated_member_use
31:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/pages/ar_placement_page.dart:790:52 • deprecated_member_use
32:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:66:42 • deprecated_member_use
33:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:72:46 • deprecated_member_use
34:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:102:28 • deprecated_member_use
35:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:107:28 • deprecated_member_use
36:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:141:22 • deprecated_member_use
37:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:142:22 • deprecated_member_use
38:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:174:28 • deprecated_member_use
39:   info • Use 'const' for final variables initialized to a constant value. Try replacing 'final' with 'const' • lib/features/ar_placement/presentation/widgets/radar_scanner.dart:178:5 • prefer_const_declarations
40:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:144:54 • deprecated_member_use
41:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:169:33 • deprecated_member_use
42:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:172:35 • deprecated_member_use
43:   info • Use 'const' with the constructor to improve performance. Try adding the 'const' keyword to the constructor invocation • lib/features/dashboard/presentation/pages/dashboard_page.dart:179:25 • prefer_const_constructors
44:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:244:41 • deprecated_member_use
45:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:266:43 • deprecated_member_use
46:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:287:45 • deprecated_member_use
47:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:392:33 • deprecated_member_use
48:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:397:35 • deprecated_member_use
49:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:417:47 • deprecated_member_use
50:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:471:41 • deprecated_member_use
51:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/dashboard_page.dart:502:37 • deprecated_member_use
52:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:148:35 • deprecated_member_use
53:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:151:39 • deprecated_member_use
54:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:201:39 • deprecated_member_use
55:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:203:41 • deprecated_member_use
56:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:210:39 • deprecated_member_use
57:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:264:41 • deprecated_member_use
58:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:334:44 • deprecated_member_use
59:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:362:37 • deprecated_member_use
60:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:383:54 • deprecated_member_use
61:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/dashboard/presentation/pages/furniture_detail_page.dart:418:31 • deprecated_member_use
62:warning • Unused import: '../../domain/entities/vr_room.dart'. Try removing the import directive • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:8:8 • unused_import
63:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:106:41 • deprecated_member_use
64:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:217:50 • deprecated_member_use
65:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:235:54 • deprecated_member_use
66:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:264:50 • deprecated_member_use
67:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:290:50 • deprecated_member_use
68:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:353:49 • deprecated_member_use
69:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:355:55 • deprecated_member_use
70:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:361:49 • deprecated_member_use
71:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:375:50 • deprecated_member_use
72:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:375:82 • deprecated_member_use
73:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:426:46 • deprecated_member_use
74:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:436:59 • deprecated_member_use
75:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:461:49 • deprecated_member_use
76:   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:480:13 • deprecated_member_use
77:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/pages/vr_tour_page.dart:481:55 • deprecated_member_use
78:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:59:58 • deprecated_member_use
79:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:77:58 • deprecated_member_use
80:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:97:56 • deprecated_member_use
81:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:120:33 • deprecated_member_use
82:   info • 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss. Try replacing the use of the deprecated member with the replacement • lib/features/vr_tour/presentation/widgets/pulsing_hotspot.dart:123:46 • deprecated_member_use
83:   info • 'background' is deprecated and shouldn't be used. Use surface instead. This feature was deprecated after v3.18.0-0.1.pre. Try replacing the use of the deprecated member with the replacement • lib/main.dart:27:11 • deprecated_member_use
84:   info • 'background' is deprecated and shouldn't be used. Use surface instead. This feature was deprecated after v3.18.0-0.1.pre. Try replacing the use of the deprecated member with the replacement • lib/main.dart:38:11 • deprecated_member_use
85:   info • Parameter 'name' could be a super parameter. Trying converting 'name' to a super parameter • packages/ar_flutter_plugin/lib/models/ar_anchor.dart:14:3 • use_super_parameters
86:  error • The name 'MyApp' isn't a class. Try correcting the name to match an existing class • test/widget_test.dart:16:35 • creation_with_non_type
87-
88-84 issues found. (ran in 5.3s)
```

### Last 300 log lines
See ci_reports/logs/flutter_analyze_tail.log after pulling the report commit.

## Android release APK
- Job result: success
- Command exit code: 0

### Probable causes
- No known pattern detected yet. Inspect the key log lines below.

### Key log lines
```text
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

