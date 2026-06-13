import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/furniture.dart';

class FurnitureModel extends Furniture {
  const FurnitureModel({
    required super.id,
    required super.name,
    required super.category,
    required super.glbPath,
  });

  factory FurnitureModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return FurnitureModel(
      id: id ?? _stringValue(json['id']),
      name: _stringValue(json['name']),
      category: _stringValue(json['category']),
      glbPath: _stringValue(json['glbPath']),
    );
  }

  factory FurnitureModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return FurnitureModel.fromJson(
      document.data() ?? const {},
      id: document.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'glbPath': glbPath,
    };
  }

  static String _stringValue(Object? value) {
    return value?.toString() ?? '';
  }
}
