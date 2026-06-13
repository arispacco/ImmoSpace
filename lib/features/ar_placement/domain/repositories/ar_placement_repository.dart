import '../../../dashboard/domain/entities/furniture.dart';

/// Abstract repository contract for AR placement data operations.
abstract class ArPlacementRepository {
  /// Fetches all furniture items available for AR projection.
  Future<List<Furniture>> getAvailableFurniture();

  /// Returns the GLB model URL for a specific furniture item.
  Future<String> getModelUrl(String furnitureId);
}
