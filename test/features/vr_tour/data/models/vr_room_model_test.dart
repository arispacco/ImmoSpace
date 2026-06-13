import 'package:flutter_test/flutter_test.dart';
import 'package:immospace/features/vr_tour/data/models/vr_room_model.dart';

void main() {
  group('VRRoomModel', () {
    test('maps JSON values and hotspot coordinates into a room entity', () {
      final model = VRRoomModel.fromJson(
        const {
          'name': 'Elegant Living Room',
          'imagePath': 'https://example.com/living-room-360.jpg',
          'hotspots': [
            {
              'id': 'to_kitchen',
              'targetRoomId': 'kitchen',
              'latitude': 45,
              'longitude': '-10.5',
              'label': 'Go to Kitchen',
            }
          ],
        },
        id: 'living_room',
      );

      expect(model.id, 'living_room');
      expect(model.name, 'Elegant Living Room');
      expect(model.imagePath, 'https://example.com/living-room-360.jpg');
      expect(model.hotspots, hasLength(1));
      expect(model.hotspots.first.id, 'to_kitchen');
      expect(model.hotspots.first.targetRoomId, 'kitchen');
      expect(model.hotspots.first.latitude, 45.0);
      expect(model.hotspots.first.longitude, -10.5);
      expect(model.hotspots.first.label, 'Go to Kitchen');
    });

    test('serializes hotspots to Firestore-compatible JSON', () {
      final model = VRRoomModel.fromJson(
        const {
          'name': 'Kitchen',
          'imagePath': 'assets/images/kitchen_360.jpg',
          'hotspots': [
            {
              'id': 'back',
              'targetRoomId': 'living_room',
              'latitude': -45,
              'longitude': 0,
              'label': 'Back',
            }
          ],
        },
        id: 'kitchen',
      );

      expect(model.toJson(), {
        'id': 'kitchen',
        'name': 'Kitchen',
        'imagePath': 'assets/images/kitchen_360.jpg',
        'hotspots': [
          {
            'id': 'back',
            'targetRoomId': 'living_room',
            'latitude': -45.0,
            'longitude': 0.0,
            'label': 'Back',
          }
        ],
      });
    });
  });
}
