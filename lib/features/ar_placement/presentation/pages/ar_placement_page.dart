import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planhandling.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../bloc/ar_placement_bloc.dart';
import '../bloc/ar_placement_event.dart';
import '../bloc/ar_placement_state.dart';
import '../../../dashboard/domain/entities/furniture.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../widgets/radar_scanner.dart';
import '../../../../core/utils/battery_optimizer.dart';

class ARPlacementPage extends StatefulWidget {
  final Furniture? selectedFurniture;

  const ARPlacementPage({super.key, this.selectedFurniture});

  @override
  State<ARPlacementPage> createState() => _ARPlacementPageState();
}

class _ARPlacementPageState extends State<ARPlacementPage> {
  // AR Manager references
  ARSessionManager? _arSessionManager;
  ARObjectManager? _arObjectManager;
  ARAnchorManager? _arAnchorManager;

  // Tracking placed nodes and anchors to prevent memory leaks on exit
  final List<ARNode> _placedNodes = [];
  final List<ARAnchor> _placedAnchors = [];

  // Local state for checking simulator fallback
  bool _useSimulationFallback = false;

  // Spatial controls state
  double _rotationAngle = 0.0; // in degrees (0 - 360)
  double _scaleFactor = 1.0;   // scale factor (0.2 - 2.0)
  bool _reduceEffects = false;

  @override
  void initState() {
    super.initState();
    _checkBatteryStatus();
  }

  Future<void> _checkBatteryStatus() async {
    final reduce = await BatteryOptimizer().shouldReduceEffects();
    if (mounted) {
      setState(() {
        _reduceEffects = reduce;
      });
    }
  }

  @override
  void dispose() {
    // CRITICAL: Clean up all placed 3D objects and anchors
    _cleanupARResources();
    super.dispose();
  }

  void _cleanupARResources() {
    if (_arObjectManager != null) {
      for (final node in _placedNodes) {
        _arObjectManager!.removeNode(node);
      }
    }
    if (_arAnchorManager != null) {
      for (final anchor in _placedAnchors) {
        _arAnchorManager!.removeAnchor(anchor);
      }
    }
    _placedNodes.clear();
    _placedAnchors.clear();
    _arSessionManager?.dispose();
  }

  void _updatePlacedModelsTransform() {
    if (_placedNodes.isEmpty) return;
    final lastNode = _placedNodes.last;
    final rad = _rotationAngle * math.pi / 180.0;
    lastNode.scale = vector.Vector3(_scaleFactor * 0.5, _scaleFactor * 0.5, _scaleFactor * 0.5);
    lastNode.rotation = vector.Vector4(0.0, 1.0, 0.0, rad);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ARPlacementBloc()..add(InitializeAREngine());
        if (widget.selectedFurniture != null) {
          bloc.add(SelectFurnitureForAR(widget.selectedFurniture!));
        }
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // AR Viewer or Simulation View
            _useSimulationFallback
                ? _buildSimulationView()
                : _buildARView(context),

            // Holographic radar scanner during initial search
            BlocBuilder<ARPlacementBloc, ARPlacementState>(
              builder: (context, state) {
                if (state is ARPlacementSuccess &&
                    state.selectedFurniture != null &&
                    !state.isPlaneDetected &&
                    !_useSimulationFallback) {
                  return const Center(
                    child: RadarScanner(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Top Status Bar (Furniture selected details)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: _buildHeaderOverlay(context),
            ),

            // Instruction Banner
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 24,
              right: 24,
              child: _buildInstructionBanner(),
            ),

            // BLoC State Loading / Success Indicator Overlay
            _buildStateOverlay(),

            // Spatial Controls Sliders (Displays when an item is selected)
            Positioned(
              bottom: 195,
              left: 16,
              right: 16,
              child: _buildSpatialControlSliders(),
            ),

            // Bottom Control Panel
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: _buildBottomControlPanel(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildARView(BuildContext context) {
    return ARView(
      onARViewCreated: (
        ARSessionManager arSessionManager,
        ARObjectManager arObjectManager,
        ARAnchorManager arAnchorManager,
        ARLocationManager arLocationManager,
      ) {
        _onARViewCreated(
          context,
          arSessionManager,
          arObjectManager,
          arAnchorManager,
          arLocationManager,
        );
      },
      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
    );
  }

  void _onARViewCreated(
    BuildContext context,
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;
    _arAnchorManager = arAnchorManager;

    _arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: "assets/images/triangle.png",
      showWorldOrigin: false,
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
    );
    _arObjectManager!.onInitialize();

    _arSessionManager!.onPlaneOrPointTap = (List<ARHitTestResult> hitTestResults) {
      _onPlaneTap(context, hitTestResults);
    };

    context.read<ARPlacementBloc>().add(const PlaneDetectedUpdate(true));
  }

  Future<void> _onPlaneTap(BuildContext context, List<ARHitTestResult> hitTestResults) async {
    final bloc = context.read<ARPlacementBloc>();
    final currentState = bloc.state;

    if (currentState is ARPlacementSuccess && currentState.selectedFurniture != null) {
      final planeHit = hitTestResults.firstWhere(
        (result) => result.type == ARHitTestResultType.plane,
      );

      final anchor = ARPlaneAnchor(pose: planeHit.worldTransform);
      final didAddAnchor = await _arAnchorManager?.addAnchor(anchor);

      if (didAddAnchor == true) {
        _placedAnchors.add(anchor);
        bloc.add(PlaceFurnitureModel(anchor.name));

        final rad = _rotationAngle * math.pi / 180.0;
        final node = ARNode(
          type: NodeType.localGLTF2,
          uri: currentState.selectedFurniture!.glbPath,
          scale: vector.Vector3(_scaleFactor * 0.5, _scaleFactor * 0.5, _scaleFactor * 0.5),
          position: vector.Vector3(0.0, 0.0, 0.0),
          rotation: vector.Vector4(0.0, 1.0, 0.0, rad),
        );

        final didAddNode = await _arObjectManager?.addNode(node, planeAnchor: anchor);
        if (didAddNode == true) {
          _placedNodes.add(node);
        }
      }
    }
  }

  Widget _buildSimulationView() {
    final rad = _rotationAngle * math.pi / 180.0;

    return Container(
      color: const Color(0xFF0F0F16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
              itemBuilder: (c, i) => Container(border: Border.all(color: Colors.white, width: 0.5)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: _scaleFactor,
                child: Transform.rotate(
                  angle: rad,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00E6FF).withOpacity(0.08),
                      border: Border.all(
                        color: const Color(0xFF00E6FF).withOpacity(0.4),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E6FF).withOpacity(0.25),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chair_alt,
                      size: 80,
                      color: Color(0xFF00E6FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'AR Simulator Active',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 6),
              Text(
                'Taps simulate horizontal surface alignment.',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final bloc = context.read<ARPlacementBloc>();
                  if (bloc.state is ARPlacementSuccess) {
                    final selected = (bloc.state as ARPlacementSuccess).selectedFurniture;
                    if (selected != null) {
                      bloc.add(const PlaceFurnitureModel('simulated_anchor_id'));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A84FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.touch_app),
                label: const Text('Simulate Surface Tap', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderOverlay(BuildContext context) {
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button in Glass
        GlassContainer(
          width: 50,
          height: 50,
          opacity: opacityVal,
          blur: blurVal,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ),

        // Simulated/Native Engine Toggle in Glass
        GlassContainer(
          height: 50,
          opacity: opacityVal,
          blur: blurVal,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _useSimulationFallback = !_useSimulationFallback;
              });
              _cleanupARResources();
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            icon: Icon(
              _useSimulationFallback ? Icons.mobile_screen_share : Icons.videocam,
              color: const Color(0xFF00E6FF),
              size: 16,
            ),
            label: Text(
              _useSimulationFallback ? 'Use Native' : 'Use Simulation',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionBanner() {
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.15;

    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        String message = 'Scanning room layout...';
        bool isLocked = false;
        if (state is ARPlacementSuccess) {
          if (state.selectedFurniture == null) {
            message = 'Select furniture from bottom drawer to start projecting';
          } else if (!state.isPlaneDetected && !_useSimulationFallback) {
            message = 'Slowly rotate phone to scan floor surface';
          } else {
            message = 'Surface detected! Tap anywhere on plane to place ${state.selectedFurniture!.name}';
            isLocked = true;
          }
        }
        return GlassContainer(
          opacity: opacityVal,
          blur: blurVal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? const Color(0xFF00E6FF).withOpacity(0.4) : const Color(0xFF8A84FF).withOpacity(0.3),
            width: 1.5,
          ),
          child: Row(
            children: [
              _buildLiveIndicator(isLocked ? const Color(0xFF00E6FF) : const Color(0xFF8A84FF)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveIndicator(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStateOverlay() {
    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        if (state is ARPlacementLoading) {
          return Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A84FF)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSpatialControlSliders() {
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.12;

    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        if (state is! ARPlacementSuccess || state.selectedFurniture == null) {
          return const SizedBox.shrink();
        }

        return GlassContainer(
          opacity: opacityVal,
          blur: blurVal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.rotate_right, color: Color(0xFF00E6FF), size: 16),
                  const SizedBox(width: 8),
                  const Text('ROTATE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF00E6FF),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                        trackHeight: 2.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        value: _rotationAngle,
                        min: 0,
                        max: 360,
                        onChanged: (val) {
                          setState(() {
                            _rotationAngle = val;
                          });
                          _updatePlacedModelsTransform();
                        },
                      ),
                    ),
                  ),
                  Text('${_rotationAngle.toInt()}°', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.photo_size_select_large_outlined, color: Color(0xFF8A84FF), size: 16),
                  const SizedBox(width: 8),
                  const Text('SCALE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF8A84FF),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                        trackHeight: 2.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        value: _scaleFactor,
                        min: 0.2,
                        max: 2.0,
                        onChanged: (val) {
                          setState(() {
                            _scaleFactor = val;
                          });
                          _updatePlacedModelsTransform();
                        },
                      ),
                    ),
                  ),
                  Text('${_scaleFactor.toStringAsFixed(1)}x', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomControlPanel(BuildContext context) {
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.15;

    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        Furniture? selected;
        int placedCount = 0;
        if (state is ARPlacementSuccess) {
          selected = state.selectedFurniture;
          placedCount = state.placedAnchorIds.length;
        }

        return GlassContainer(
          opacity: opacityVal,
          blur: blurVal,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              selected != null ? 'Selected: ${selected.name}' : 'No Furniture Selected',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (_reduceEffects) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('SAVER', style: TextStyle(color: Colors.amber, fontSize: 6, fontWeight: FontWeight.bold)),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selected != null ? 'File: ${selected.glbPath.split('/').last}' : 'Tap grid item below',
                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E6FF).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF00E6FF).withOpacity(0.2), width: 1),
                        ),
                        child: Text(
                          '$placedCount Projected',
                          style: const TextStyle(color: Color(0xFF00E6FF), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                        onPressed: () {
                          _cleanupARResources();
                          context.read<ARPlacementBloc>().add(ClearPlacedModels());
                        },
                        tooltip: 'Clear placement anchors',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSwitchItemCard(
                      context,
                      const Furniture(
                        id: '1',
                        name: 'Sofa',
                        category: 'Living Room',
                        glbPath: 'assets/models/sofa.glb',
                      ),
                      selected,
                    ),
                    _buildSwitchItemCard(
                      context,
                      const Furniture(
                        id: '2',
                        name: 'Chair',
                        category: 'Dining Room',
                        glbPath: 'assets/models/chair.glb',
                      ),
                      selected,
                    ),
                    _buildSwitchItemCard(
                      context,
                      const Furniture(
                        id: '3',
                        name: 'Table',
                        category: 'Office',
                        glbPath: 'assets/models/table.glb',
                      ),
                      selected,
                    ),
                    _buildSwitchItemCard(
                      context,
                      const Furniture(
                        id: '4',
                        name: 'Lamp',
                        category: 'Bedroom',
                        glbPath: 'assets/models/lamp.glb',
                      ),
                      selected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwitchItemCard(BuildContext context, Furniture furniture, Furniture? currentSelected) {
    final isSelected = currentSelected?.id == furniture.id;
    return GestureDetector(
      onTap: () {
        context.read<ARPlacementBloc>().add(SelectFurnitureForAR(furniture));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF8A84FF), Color(0xFF6C63FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E6FF).withOpacity(0.8) : Colors.white12,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8A84FF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chair_outlined,
                size: 16,
                color: isSelected ? Colors.white : Colors.white54,
              ),
              const SizedBox(height: 4),
              Text(
                furniture.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
