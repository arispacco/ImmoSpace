import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../datatypes/config_planedetection.dart';
import '../datatypes/hittest_result_types.dart';
import '../managers/ar_anchor_manager.dart';
import '../managers/ar_location_manager.dart';
import '../managers/ar_object_manager.dart';
import '../managers/ar_session_manager.dart';
import '../models/ar_hittest_result.dart';

typedef ARViewCreatedCallback = void Function(
  ARSessionManager arSessionManager,
  ARObjectManager arObjectManager,
  ARAnchorManager arAnchorManager,
  ARLocationManager arLocationManager,
);

class ARView extends StatefulWidget {
  final ARViewCreatedCallback onARViewCreated;
  final PlaneDetectionConfig planeDetectionConfig;

  const ARView({
    super.key,
    required this.onARViewCreated,
    this.planeDetectionConfig = PlaneDetectionConfig.horizontalAndVertical,
  });

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  late final ARSessionManager _sessionManager;
  late final ARObjectManager _objectManager;
  late final ARAnchorManager _anchorManager;
  late final ARLocationManager _locationManager;

  @override
  void initState() {
    super.initState();
    _sessionManager = ARSessionManager();
    _objectManager = ARObjectManager();
    _anchorManager = ARAnchorManager();
    _locationManager = ARLocationManager();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onARViewCreated(
        _sessionManager,
        _objectManager,
        _anchorManager,
        _locationManager,
      );
    });
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }

  void _simulatePlaneTap() {
    _sessionManager.onPlaneOrPointTap?.call(
      <ARHitTestResult>[
        ARHitTestResult(
          type: ARHitTestResultType.plane,
          worldTransform: vector.Matrix4.identity(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (_) => _simulatePlaneTap(),
      child: Container(
        color: const Color(0xFF0F0F16),
        alignment: Alignment.center,
        child: const Icon(
          Icons.view_in_ar,
          color: Color(0xFF00E6FF),
          size: 72,
        ),
      ),
    );
  }
}
