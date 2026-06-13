import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/furniture.dart';

abstract class ARPlacementState extends Equatable {
  const ARPlacementState();

  @override
  List<Object?> get props => [];
}

class ARPlacementInitial extends ARPlacementState {}

class ARPlacementLoading extends ARPlacementState {
  final String message;

  const ARPlacementLoading({this.message = 'Initializing AR View...'});

  @override
  List<Object?> get props => [message];
}

class ARPlacementSuccess extends ARPlacementState {
  final List<Furniture> availableFurniture;
  final Furniture? selectedFurniture;
  final bool isPlaneDetected;
  final List<String> placedAnchorIds;

  const ARPlacementSuccess({
    this.availableFurniture = const [],
    this.selectedFurniture,
    this.isPlaneDetected = false,
    this.placedAnchorIds = const [],
  });

  ARPlacementSuccess copyWith({
    List<Furniture>? availableFurniture,
    Furniture? selectedFurniture,
    bool? isPlaneDetected,
    List<String>? placedAnchorIds,
  }) {
    return ARPlacementSuccess(
      availableFurniture: availableFurniture ?? this.availableFurniture,
      selectedFurniture: selectedFurniture ?? this.selectedFurniture,
      isPlaneDetected: isPlaneDetected ?? this.isPlaneDetected,
      placedAnchorIds: placedAnchorIds ?? this.placedAnchorIds,
    );
  }

  @override
  List<Object?> get props => [availableFurniture, selectedFurniture, isPlaneDetected, placedAnchorIds];
}

class ARPlacementError extends ARPlacementState {
  final String message;

  const ARPlacementError(this.message);

  @override
  List<Object?> get props => [message];
}
