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
  final Furniture? selectedFurniture;
  final bool isPlaneDetected;
  final List<String> placedAnchorIds;

  const ARPlacementSuccess({
    this.selectedFurniture,
    this.isPlaneDetected = false,
    this.placedAnchorIds = const [],
  });

  ARPlacementSuccess copyWith({
    Furniture? selectedFurniture,
    bool? isPlaneDetected,
    List<String>? placedAnchorIds,
  }) {
    return ARPlacementSuccess(
      selectedFurniture: selectedFurniture ?? this.selectedFurniture,
      isPlaneDetected: isPlaneDetected ?? this.isPlaneDetected,
      placedAnchorIds: placedAnchorIds ?? this.placedAnchorIds,
    );
  }

  @override
  List<Object?> get props => [selectedFurniture, isPlaneDetected, placedAnchorIds];
}

class ARPlacementError extends ARPlacementState {
  final String message;

  const ARPlacementError(this.message);

  @override
  List<Object?> get props => [message];
}
