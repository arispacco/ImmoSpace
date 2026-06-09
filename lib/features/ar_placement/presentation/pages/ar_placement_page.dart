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

  @override
  void dispose() {
    // CRITICAL: Clean up all placed 3D objects and anchors
    _cleanupARResources();
    super.dispose();
  }

  void _cleanupARResources() {
    // Remove all loaded 3D nodes from memory
    if (_arObjectManager != null) {
      for (final node in _placedNodes) {
        _arObjectManager!.removeNode(node);
      }
    }
    // Remove all registered anchors
    if (_arAnchorManager != null) {
      for (final anchor in _placedAnchors) {
        _arAnchorManager!.removeAnchor(anchor);
      }
    }
    // Clear local tracking lists
    _placedNodes.clear();
    _placedAnchors.clear();

    // Call dispose on session managers if supported
    _arSessionManager?.dispose();
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

    // Initialize session with customized visual settings
    _arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: "assets/images/triangle.png",
      showWorldOrigin: false,
      handleTaps: true,
    );
    _arObjectManager!.onInitialize();

    // Set callback tap listeners
    _arSessionManager!.onPlaneOrPointTap = (List<ARHitTestResult> hitTestResults) {
      _onPlaneTap(context, hitTestResults);
    };

    // Update BLoC that plane detection is scanning/active
    context.read<ARPlacementBloc>().add(const PlaneDetectedUpdate(true));
  }

  // Handle taps on detected real-world surfaces
  Future<void> _onPlaneTap(BuildContext context, List<ARHitTestResult> hitTestResults) async {
    final bloc = context.read<ARPlacementBloc>();
    final currentState = bloc.state;

    if (currentState is ARPlacementSuccess && currentState.selectedFurniture != null) {
      // Find the first valid plane collision result
      final planeHit = hitTestResults.firstWhere(
        (result) => result.type == ARHitTestResultType.plane,
      );

      // Create a unique anchor at the tapped surface position
      final anchor = ARPlaneAnchor(pose: planeHit.worldTransform);
      final didAddAnchor = await _arAnchorManager?.addAnchor(anchor);

      if (didAddAnchor == true) {
        _placedAnchors.add(anchor);
        bloc.add(PlaceFurnitureModel(anchor.name));

        // Load the 3D model node attached to this anchor
        final node = ARNode(
          type: NodeType.localGLTF2,
          uri: currentState.selectedFurniture!.glbPath,
          scale: vector.Vector3(0.5, 0.5, 0.5),
          position: vector.Vector3(0.0, 0.0, 0.0),
          rotation: vector.Vector4(0.0, 1.0, 0.0, 0.0),
        );

        final didAddNode = await _arObjectManager?.addNode(node, planeAnchor: anchor);
        if (didAddNode == true) {
          _placedNodes.add(node);
        }
      }
    }
  }

  // Elegant simulation camera screen for emulators/non-AR devices
  Widget _buildSimulationView() {
    return Container(
      color: Colors.grey[900],
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated camera static/visual grid
          Opacity(
            opacity: 0.15,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
              itemBuilder: (c, i) => Container(border: Border.all(color: Colors.white, width: 0.5)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_outlined, size: 72, color: Color(0xFF00E6FF)),
              const SizedBox(height: 12),
              const Text(
                'AR Simulator Active',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                ),
                icon: const Icon(Icons.touch_app),
                label: const Text('Simulate Surface Tap'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderOverlay(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),

        // Simulated/Native Engine Toggle
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _useSimulationFallback = !_useSimulationFallback;
                });
                _cleanupARResources();
              },
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
        ),
      ],
    );
  }

  Widget _buildInstructionBanner() {
    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        String message = 'Scanning room layout...';
        if (state is ARPlacementSuccess) {
          if (state.selectedFurniture == null) {
            message = 'Select furniture from bottom drawer to start projecting';
          } else if (!state.isPlaneDetected && !_useSimulationFallback) {
            message = 'Slowly rotate phone to scan floor surface';
          } else {
            message = 'Surface detected! Tap anywhere on plane to place ${state.selectedFurniture!.name}';
          }
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8A84FF).withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF00E6FF), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildBottomControlPanel(BuildContext context) {
    return BlocBuilder<ARPlacementBloc, ARPlacementState>(
      builder: (context, state) {
        Furniture? selected;
        int placedCount = 0;
        if (state is ARPlacementSuccess) {
          selected = state.selectedFurniture;
          placedCount = state.placedAnchorIds.length;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E).withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Furniture projection info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected != null ? 'Selected: ${selected.name}' : 'No Furniture Selected',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          selected != null ? 'File: ${selected.glbPath.split('/').last}' : 'Tap grid item below',
                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Active projection count indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A84FF).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$placedCount Projected',
                          style: const TextStyle(color: Color(0xFF8A84FF), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Clear button
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
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

              // Horizontal miniature list for quick switching models
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8A84FF).withOpacity(0.15) : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8A84FF) : Colors.white12,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chair_outlined,
                size: 18,
                color: isSelected ? const Color(0xFF8A84FF) : Colors.white54,
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
