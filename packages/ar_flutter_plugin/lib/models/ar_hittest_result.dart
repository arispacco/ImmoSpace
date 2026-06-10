import 'package:vector_math/vector_math_64.dart';

import '../datatypes/hittest_result_types.dart';

class ARHitTestResult {
  final ARHitTestResultType type;
  final Matrix4 worldTransform;

  const ARHitTestResult({
    required this.type,
    required this.worldTransform,
  });
}
