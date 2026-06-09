import '../../domain/entities/furniture.dart';

class FurnitureModel extends Furniture {
  const FurnitureModel({
    required super.id,
    required super.name,
    required super.category,
    required super.glbPath,
  });

  factory FurnitureModel.fromJson(Map<String, dynamic> json) {
    return FurnitureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      glbPath: json['glbPath'] as String,
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
}
