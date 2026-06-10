import 'package:vector_math/vector_math_64.dart';

import '../datatypes/node_types.dart';

class ARNode {
  final NodeType type;
  final String uri;
  Vector3 scale;
  Vector3 position;
  Vector3 eulerAngles;

  ARNode({
    required this.type,
    required this.uri,
    required this.scale,
    required this.position,
    required this.eulerAngles,
  });
}
