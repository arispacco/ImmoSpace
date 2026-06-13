import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/vr_tour_bloc.dart';
import '../bloc/vr_tour_event.dart';
import '../bloc/vr_tour_state.dart';
import '../../domain/entities/vr_room.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../widgets/pulsing_hotspot.dart';
import '../../../../core/utils/battery_optimizer.dart';

class VRTourPage extends StatefulWidget {
  const VRTourPage({super.key});

  @override
  State<VRTourPage> createState() => _VRTourPageState();
}

class _VRTourPageState extends State<VRTourPage> {
  // Option to toggle sensor-based controls (gyroscope/orientation)
  SensorControl _sensorControl = SensorControl.orientation;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VRTourBloc>()..add(InitVRTour()),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // VR 360 Panorama View
            BlocBuilder<VRTourBloc, VRTourState>(
              builder: (context, state) {
                if (state is VRTourLoaded) {
                  return PanoramaViewer(
                    animSpeed: 0.3,
                    sensorControl: _sensorControl,
                    hotspots: state.currentRoom.hotspots.map((hotspot) {
                      return Hotspot(
                        latitude: hotspot.latitude,
                        longitude: hotspot.longitude,
                        width: 100.0,
                        height: 100.0,
                        widget: PulsingHotspot(
                          label: hotspot.label,
                          onTap: () {
                            context.read<VRTourBloc>().add(NavigateToRoom(hotspot.targetRoomId));
                          },
                        ),
                      );
                    }).toList(),
                    child: _buildPanoramaImage(state.currentRoom),
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

            // Horizontal Room Switcher Drawer (Above bottom action panel)
            Positioned(
              bottom: 110,
              left: 16,
              right: 16,
              child: _buildRoomDrawer(context),
            ),

            // Bottom Actions Control Panel
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: _buildControlPanel(),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPanoramaImage(VRRoom room) {
    if (_isRemotePath(room.imagePath)) {
      return Image.network(
        room.imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _buildMockPanorama(room.name);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildMockPanorama(room.name);
        },
      );
    }

    return Image.asset(
      room.imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildMockPanorama(room.name);
      },
    );
  }

  bool _isRemotePath(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
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

        // Title Info in Glass
        BlocBuilder<VRTourBloc, VRTourState>(
          builder: (context, state) {
            String roomTitle = 'Loading...';
            if (state is VRTourLoaded) {
              roomTitle = state.currentRoom.name;
            }
            return GlassContainer(
              opacity: opacityVal,
              blur: blurVal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF00E6FF), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    roomTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Settings/Help shortcut in Glass
        GlassContainer(
          width: 50,
          height: 50,
          opacity: opacityVal,
          blur: blurVal,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          child: IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 20),
            onPressed: () => _showHelpDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomDrawer(BuildContext context) {
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.12;

    return BlocBuilder<VRTourBloc, VRTourState>(
      builder: (context, state) {
        if (state is! VRTourLoaded) return const SizedBox.shrink();

        final activeRoomId = state.currentRoom.id;
        final rooms = state.rooms.isNotEmpty
            ? state.rooms
            : <VRRoom>[state.currentRoom];

        return GlassContainer(
          height: 90,
          opacity: opacityVal,
          blur: blurVal,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _buildRoomCard(
                context,
                id: room.id,
                name: room.name,
                icon: _roomIcon(room),
                gradientColors: _roomGradient(index),
                isActive: activeRoomId == room.id,
              );
            },
          ),
        );
      },
    );
  }

  IconData _roomIcon(VRRoom room) {
    final key = '${room.id} ${room.name}'.toLowerCase();
    if (key.contains('kitchen')) return Icons.kitchen;
    if (key.contains('balcony')) return Icons.balcony;
    if (key.contains('bed')) return Icons.bed_outlined;
    if (key.contains('bath')) return Icons.bathtub_outlined;
    if (key.contains('office')) return Icons.business_center_outlined;
    return Icons.meeting_room_outlined;
  }

  List<Color> _roomGradient(int index) {
    const palettes = [
      [Color(0xFF6C63FF), Color(0xFF3B33C7)],
      [Color(0xFF00E6FF), Color(0xFF00869B)],
      [Color(0xFF8A84FF), Color(0xFF4FACFE)],
      [Color(0xFF1D976C), Color(0xFF11432E)],
    ];
    return palettes[index % palettes.length];
  }

  Widget _buildRoomCard(
    BuildContext context, {
    required String id,
    required String name,
    required IconData icon,
    required List<Color> gradientColors,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.read<VRTourBloc>().add(NavigateToRoom(id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: isActive ? const Color(0xFF00E6FF).withOpacity(0.8) : Colors.white12,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? 'Viewing' : 'Explore',
                      style: TextStyle(
                        color: isActive ? Colors.white70 : Colors.white38,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    final bool isGyro = _sensorControl == SensorControl.orientation;
    final blurVal = _reduceEffects ? 0.0 : 12.0;
    final opacityVal = _reduceEffects ? 0.35 : 0.12;

    return GlassContainer(
      opacity: opacityVal,
      blur: blurVal,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.06)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGyro ? const Color(0xFF00E6FF).withOpacity(0.15) : Colors.white10,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGyro ? Icons.screen_rotation : Icons.touch_app,
                  color: isGyro ? const Color(0xFF00E6FF) : Colors.white60,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'VR Control Mode',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      if (_reduceEffects) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('BATTERY OPTIMIZED', style: TextStyle(color: Colors.amber, fontSize: 6, fontWeight: FontWeight.bold)),
                        ),
                      ]
                    ],
                  ),
                  Text(
                    isGyro ? 'Gyroscope / Sensor Active' : 'Touch / Drag Gestures Active',
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),

          Switch(
            value: isGyro,
            activeColor: const Color(0xFF00E6FF),
            activeTrackColor: const Color(0xFF00E6FF).withOpacity(0.2),
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white12,
            onChanged: (bool val) {
              setState(() {
                _sensorControl = val ? SensorControl.orientation : SensorControl.none;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    val ? 'Switched to Gyroscope Navigation' : 'Switched to Touch Navigation',
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFF1E1E2E),
                ),
              );
            },
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
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF00E6FF)),
            SizedBox(width: 10),
            Text(
              'VR Navigation Help',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Move your device to look around via gyroscope sensors.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            SizedBox(height: 10),
            Text(
              '• Or drag/swipe the screen to manually rotate the viewpoint.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            SizedBox(height: 10),
            Text(
              '• Click on the glowing blue hotspots to navigate to adjacent rooms.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color(0xFF00E6FF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
