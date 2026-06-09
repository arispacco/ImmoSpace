import 'package:equatable/equatable.dart';

class Furniture extends Equatable {
  final String id;
  final String name;
  final String category;
  final String glbPath;

  const Furniture({
    required this.id,
    required this.name,
    required this.category,
    required this.glbPath,
  });

  Furniture copyWith({
    String? id,
    String? name,
    String? category,
    String? glbPath,
  }) {
    return Furniture(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      glbPath: glbPath ?? this.glbPath,
    );
  }

  @override
  List<Object?> get props => [id, name, category, glbPath];
}
