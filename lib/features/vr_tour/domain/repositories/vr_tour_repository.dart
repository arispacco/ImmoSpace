import '../entities/vr_room.dart';

/// Abstract repository contract for VR tour data operations.
abstract class VrTourRepository {
  /// Fetches all available VR rooms.
  Future<List<VRRoom>> getRooms();

  /// Fetches a specific room by its ID.
  Future<VRRoom?> getRoomById(String id);

  /// Fetches the starting room for the VR Tour.
  Future<VRRoom?> fetchInitialRoom();

  /// Adds a new VR room to the repository (local/remote).
  Future<void> addRoom(VRRoom room);
}
