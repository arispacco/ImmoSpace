import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadFurnitureList extends DashboardEvent {}

class SearchFurniture extends DashboardEvent {
  final String query;
  final String category;

  const SearchFurniture({this.query = '', this.category = ''});

  @override
  List<Object?> get props => [query, category];
}
