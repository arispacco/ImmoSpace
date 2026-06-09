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

  @override
  List<Object?> get props => [id, name, category, glbPath];
}
