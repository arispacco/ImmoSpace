import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/furniture.dart';

abstract class ARPlacementEvent extends Equatable {
  const ARPlacementEvent();

  @override
  List<Object?> get props => [];
}

class InitializeAREngine extends ARPlacementEvent {
  final Furniture? initialFurniture;

  const InitializeAREngine({this.initialFurniture});

  @override
  List<Object?> get props => [initialFurniture];
}

class SelectFurnitureForAR extends ARPlacementEvent {
  final Furniture furniture;

  const SelectFurnitureForAR(this.furniture);

  @override
  List<Object?> get props => [furniture];
}

class PlaneDetectedUpdate extends ARPlacementEvent {
  final bool isDetected;

  const PlaneDetectedUpdate(this.isDetected);

  @override
  List<Object?> get props => [isDetected];
}

class PlaceFurnitureModel extends ARPlacementEvent {
  final String anchorId;

  const PlaceFurnitureModel(this.anchorId);

  @override
  List<Object?> get props => [anchorId];
}

class ClearPlacedModels extends ARPlacementEvent {}
