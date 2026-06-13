import '../../domain/entities/furniture.dart';

/// Local datasource providing hardcoded furniture data.
/// This is where mock data lives, extracted from the BLoC layer
/// to respect clean architecture separation of concerns.
class FurnitureLocalDatasource {
  static const String _sofaModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/GlamVelvetSofa/glTF-Binary/GlamVelvetSofa.glb';
  static const String _chairModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ChairDamaskPurplegold/glTF-Binary/ChairDamaskPurplegold.glb';
  static const String _tableModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ClearcoatWicker/glTF-Binary/ClearcoatWicker.glb';
  static const String _lampModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/IridescenceLamp/glTF-Binary/IridescenceLamp.glb';

  static const List<Furniture> _furnitureCatalog = [
    Furniture(
      id: '1',
      name: 'Modern Sofa',
      category: 'Living Room',
      glbPath: _sofaModelUrl,
    ),
    Furniture(
      id: '2',
      name: 'Minimalist Chair',
      category: 'Dining Room',
      glbPath: _chairModelUrl,
    ),
    Furniture(
      id: '3',
      name: 'Nordic Table',
      category: 'Office',
      glbPath: _tableModelUrl,
    ),
    Furniture(
      id: '4',
      name: 'Futuristic Lamp',
      category: 'Bedroom',
      glbPath: _lampModelUrl,
    ),
    Furniture(
      id: '5',
      name: 'Designer Sheen Chair',
      category: 'Living Room',
      glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/SheenChair/glTF-Binary/SheenChair.glb',
    ),
    Furniture(
      id: '6',
      name: 'Antique Decor Camera',
      category: 'Office',
      glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/AntiqueCamera/glTF-Binary/AntiqueCamera.glb',
    ),
  ];

  /// Returns the full furniture catalog after a simulated delay.
  Future<List<Furniture>> getFurnitureList() async {
    // Simulating network or database latency
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_furnitureCatalog);
  }

  /// Searches furniture by name (case-insensitive partial match).
  Future<List<Furniture>> searchFurniture(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _furnitureCatalog
        .where((f) => f.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filters furniture by exact category match.
  Future<List<Furniture>> getFurnitureByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _furnitureCatalog
        .where((f) => f.category == category)
        .toList();
  }
}
