import '../entities/vr_room.dart';

/// Abstract repository contract for VR tour data operations.
abstract class VrTourRepository {
  /// Fetches all available VR rooms.
  Future<List<VRRoom>> getRooms();

  /// Fetches a specific room by its ID.
  Future<VRRoom?> getRoomById(String id);

  /// Fetches the starting room for the VR Tour.
  Future<VRRoom?> fetchInitialRoom();
}
