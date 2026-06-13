import '../../domain/entities/vr_room.dart';

/// Local datasource providing hardcoded VR room data.
/// Mock rooms extracted from VRTourBloc to respect clean architecture.
class VrTourLocalDatasource {
  static final Map<String, VRRoom> _mockRooms = {
    'living_room': const VRRoom(
      id: 'living_room',
      name: 'Elegant Living Room',
      imagePath: 'assets/images/living_room_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h1',
          targetRoomId: 'kitchen',
          latitude: 45.0,
          longitude: 0.0,
          label: 'Go to Kitchen',
        ),
      ],
    ),
    'kitchen': const VRRoom(
      id: 'kitchen',
      name: 'Modern Kitchen',
      imagePath: 'assets/images/kitchen_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h2',
          targetRoomId: 'living_room',
          latitude: -45.0,
          longitude: 0.0,
          label: 'Back to Living Room',
        ),
        VRHotspot(
          id: 'h3',
          targetRoomId: 'balcony',
          latitude: 120.0,
          longitude: -10.0,
          label: 'Step onto Balcony',
        ),
      ],
    ),
    'balcony': const VRRoom(
      id: 'balcony',
      name: 'Panoramic Balcony',
      imagePath: 'assets/images/balcony_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h4',
          targetRoomId: 'kitchen',
          latitude: -120.0,
          longitude: 10.0,
          label: 'Return to Kitchen',
        ),
      ],
    ),
  };

  /// Returns all available VR rooms.
  Future<List<VRRoom>> getRooms() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRooms.values.toList();
  }

  /// Returns a specific room by ID. Throws if not found.
  Future<VRRoom> getRoomById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final room = _mockRooms[id];
    if (room == null) {
      throw Exception('Room "$id" not found.');
    }
    return room;
  }
}
