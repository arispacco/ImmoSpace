import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/vr_room.dart';

class VRRoomModel extends VRRoom {
  const VRRoomModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.hotspots,
  });

  factory VRRoomModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawHotspots = json['hotspots'] as List<dynamic>? ?? const [];
    final hotspotsList = rawHotspots.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      return VRHotspot(
        id: _stringValue(map['id']),
        targetRoomId: _stringValue(map['targetRoomId']),
        latitude: _doubleValue(map['latitude']),
        longitude: _doubleValue(map['longitude']),
        label: _stringValue(map['label']),
      );
    }).toList();

    return VRRoomModel(
      id: id ?? _stringValue(json['id']),
      name: _stringValue(json['name']),
      imagePath: _stringValue(json['imagePath']),
      hotspots: hotspotsList,
    );
  }

  factory VRRoomModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return VRRoomModel.fromJson(
      document.data() ?? const {},
      id: document.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'hotspots': hotspots.map((h) => {
        'id': h.id,
        'targetRoomId': h.targetRoomId,
        'latitude': h.latitude,
        'longitude': h.longitude,
        'label': h.label,
      }).toList(),
    };
  }

  static String _stringValue(Object? value) {
    return value?.toString() ?? '';
  }

  static double _doubleValue(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
