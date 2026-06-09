import 'package:equatable/equatable.dart';

class VRRoom extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final List<VRHotspot> hotspots;

  const VRRoom({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.hotspots,
  });

  @override
  List<Object?> get props => [id, name, imagePath, hotspots];
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
