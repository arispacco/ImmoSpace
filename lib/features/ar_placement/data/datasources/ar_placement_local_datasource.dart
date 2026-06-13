import '../../../dashboard/domain/entities/furniture.dart';

/// Local datasource providing furniture data for AR placement.
/// Shares the same catalog as the dashboard feature.
class ArPlacementLocalDatasource {
  static const String _sofaModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/GlamVelvetSofa/glTF-Binary/GlamVelvetSofa.glb';
  static const String _chairModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ChairDamaskPurplegold/glTF-Binary/ChairDamaskPurplegold.glb';
  static const String _tableModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ClearcoatWicker/glTF-Binary/ClearcoatWicker.glb';
  static const String _lampModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/IridescenceLamp/glTF-Binary/IridescenceLamp.glb';

  static const List<Furniture> _furnitureCatalog = [
    Furniture(id: '1', name: 'Sofa', category: 'Living Room', glbPath: _sofaModelUrl),
    Furniture(id: '2', name: 'Chair', category: 'Dining Room', glbPath: _chairModelUrl),
    Furniture(id: '3', name: 'Table', category: 'Office', glbPath: _tableModelUrl),
    Furniture(id: '4', name: 'Lamp', category: 'Bedroom', glbPath: _lampModelUrl),
    Furniture(
      id: '5',
      name: 'Sheen Chair',
      category: 'Living Room',
      glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/SheenChair/glTF-Binary/SheenChair.glb',
    ),
    Furniture(
      id: '6',
      name: 'Camera Decor',
      category: 'Office',
      glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/AntiqueCamera/glTF-Binary/AntiqueCamera.glb',
    ),
  ];

  /// Returns all furniture items available for AR placement.
  Future<List<Furniture>> getAvailableFurniture() async {
    return List.unmodifiable(_furnitureCatalog);
  }

  /// Returns the GLB model URL for a specific furniture item.
  Future<String> getModelUrl(String furnitureId) async {
    final furniture = _furnitureCatalog.firstWhere(
      (f) => f.id == furnitureId,
      orElse: () => throw Exception('Furniture "$furnitureId" not found.'),
    );
    return furniture.glbPath;
  }
}
