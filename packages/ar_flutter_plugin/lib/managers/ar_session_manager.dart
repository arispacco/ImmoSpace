import '../models/ar_hittest_result.dart';

typedef ARPlaneOrPointTap = void Function(List<ARHitTestResult> hitTestResults);

class ARSessionManager {
  ARPlaneOrPointTap? onPlaneOrPointTap;

  Future<void> onInitialize({
    bool showFeaturePoints = false,
    bool showPlanes = false,
    String? customPlaneTexturePath,
    bool showWorldOrigin = false,
    bool handleTaps = false,
    bool handlePans = false,
    bool handleRotation = false,
  }) async {}

  void dispose() {
    onPlaneOrPointTap = null;
  }
}
