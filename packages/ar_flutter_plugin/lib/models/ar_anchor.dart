import 'package:vector_math/vector_math_64.dart';

class ARAnchor {
  final String name;
  final Matrix4? transformation;

  ARAnchor({
    String? name,
    this.transformation,
  }) : name = name ?? 'anchor_${DateTime.now().microsecondsSinceEpoch}';
}

class ARPlaneAnchor extends ARAnchor {
  ARPlaneAnchor({
    required Matrix4 transformation,
    String? name,
  }) : super(name: name, transformation: transformation);
}
