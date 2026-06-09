import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../bloc/vr_tour_bloc.dart';
import '../bloc/vr_tour_event.dart';
import '../bloc/vr_tour_state.dart';
import '../../domain/entities/vr_room.dart';

class VRTourPage extends StatefulWidget {
  const VRTourPage({super.key});

  @override
  State<VRTourPage> createState() => _VRTourPageState();
}

class _VRTourPageState extends State<VRTourPage> {
  // Option to toggle sensor-based controls (gyroscope/orientation)
  SensorControl _sensorControl = SensorControl.orientation;

  @override
  void dispose() {
    // Correctly clean up any custom controllers or sensors if needed.
    // The PanoramaViewer widget disposes of its internal sensor streams,
    // but explicit lifecycle tracking prevents leaks in sub-widgets.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VRTourBloc()..add(InitVRTour()),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // VR 360 Panorama View
            BlocBuilder<VRTourBloc, VRTourState>(
              builder: (context, state) {
                if (state is VRTourLoaded) {
                  return PanoramaViewer(
                    animSpeed: 0.5,
                    sensorControl: _sensorControl,
                    hotspots: state.currentRoom.hotspots.map((hotspot) {
                      return Hotspot(
                        latitude: hotspot.latitude,
                        longitude: hotspot.longitude,
                        width: 90.0,
                        height: 90.0,
                        widget: _buildHotspotButton(context, hotspot),
                      );
                    }).toList(),
                    child: Image.asset(
                      state.currentRoom.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Return a stylized premium mockup if image asset is missing
                        return _buildMockPanorama(state.currentRoom.name);
                      },
                    ),
                  );
                } else if (state is VRTourError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Loading Overlay
            BlocBuilder<VRTourBloc, VRTourState>(
              builder: (context, state) {
                if (state is VRTourLoading || state is VRTourInitial) {
                  return Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E6FF)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading Immersive 360° Scene...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Navigation Header & Status Overlay
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: _buildHeaderOverlay(context),
            ),

            // Bottom Actions Control Panel
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: _buildControlPanel(),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback visual simulation for testing/mock environments without real 360 images loaded
  Widget _buildMockPanorama(String roomName) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF1E1E2F), Color(0xFF0B0B0F)],
          radius: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.threed_rotation,
              size: 80,
              color: Color(0xFF8A84FF),
            ),
            const SizedBox(height: 16),
            Text(
              '360° Preview: $roomName',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Drag the screen or rotate your phone to explore the VR environment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotspotButton(BuildContext context, VRHotspot hotspot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00E6FF).withOpacity(0.2),
            border: Border.all(color: const Color(0xFF00E6FF), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E6FF).withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<VRTourBloc>().add(NavigateToRoom(hotspot.targetRoomId));
              },
              shape: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          child: Text(
            hotspot.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

        // Title Info
        BlocBuilder<VRTourBloc, VRTourState>(
          builder: (context, state) {
            String roomTitle = 'Loading...';
            if (state is VRTourLoaded) {
              roomTitle = state.currentRoom.name;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF8A84FF), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    roomTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Placeholder for align
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildControlPanel() {
    final bool isGyro = _sensorControl == SensorControl.orientation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Gyro / Touch Control Toggle
          IconButton(
            icon: Icon(
              isGyro ? Icons.screen_rotation : Icons.touch_app,
              color: isGyro ? const Color(0xFF00E6FF) : Colors.white60,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _sensorControl = isGyro ? SensorControl.none : SensorControl.orientation;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isGyro ? 'Switched to Touch Navigation' : 'Switched to Gyroscope Navigation',
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFF1E1E2E),
                ),
              );
            },
            tooltip: 'Toggle Gyroscope / Drag controls',
          ),

          // Help instructions modal
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 28),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'VR Navigation Help',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Move your device to look around via gyroscope.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              '• Or drag/swipe the screen to manually rotate the viewpoint.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              '• Click on the blue circular hotspots to travel to other rooms.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color(0xFF00E6FF))),
          ),
        ],
      ),
    );
  }
}
