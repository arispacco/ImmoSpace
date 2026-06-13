import 'package:equatable/equatable.dart';

class VRRoom extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final List<VRHotspot> hotspots;
  // Position on the 2D floor plan (0.0 to 1.0 relative to plan size)
  final double x;
  final double y;

  const VRRoom({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.hotspots,
    this.x = 0.5,
    this.y = 0.5,
  });

  @override
  List<Object?> get props => [id, name, imagePath, hotspots, x, y];
}

class VRHotspot extends Equatable {
  final String id;
  final String targetRoomId;
  final double latitude; // Horizontal rotation
  final double longitude; // Vertical rotation
  final String label;

  const VRHotspot({
    required this.id,
    required this.targetRoomId,
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  @override
  List<Object?> get props => [id, targetRoomId, latitude, longitude, label];
}
