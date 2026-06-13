import 'package:flutter_test/flutter_test.dart';
import 'package:immospace/features/dashboard/data/models/furniture_model.dart';

void main() {
  group('FurnitureModel', () {
    test('maps JSON values into a furniture entity', () {
      final model = FurnitureModel.fromJson(
        const {
          'name': 'Modern Sofa',
          'category': 'Living Room',
          'glbPath': 'https://example.com/sofa.glb',
        },
        id: 'sofa_1',
      );

      expect(model.id, 'sofa_1');
      expect(model.name, 'Modern Sofa');
      expect(model.category, 'Living Room');
      expect(model.glbPath, 'https://example.com/sofa.glb');
    });

    test('serializes to Firestore-compatible JSON', () {
      const model = FurnitureModel(
        id: 'chair_1',
        name: 'Minimalist Chair',
        category: 'Dining Room',
        glbPath: 'https://example.com/chair.glb',
      );

      expect(model.toJson(), {
        'id': 'chair_1',
        'name': 'Minimalist Chair',
        'category': 'Dining Room',
        'glbPath': 'https://example.com/chair.glb',
      });
    });
  });
}
