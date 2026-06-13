import '../entities/furniture.dart';

/// Abstract repository contract for furniture data operations.
abstract class FurnitureRepository {
  /// Fetches the complete list of available furniture items.
  Future<List<Furniture>> getFurnitureList();

  /// Searches furniture by name (case-insensitive partial match).
  Future<List<Furniture>> searchFurniture(String query);

  /// Filters furniture by category.
  Future<List<Furniture>> getFurnitureByCategory(String category);
}
