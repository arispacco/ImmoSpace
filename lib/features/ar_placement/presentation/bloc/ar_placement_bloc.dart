import 'package:flutter_bloc/flutter_bloc.dart';
import 'ar_placement_event.dart';
import 'ar_placement_state.dart';

class ARPlacementBloc extends Bloc<ARPlacementEvent, ARPlacementState> {
  ARPlacementBloc() : super(ARPlacementInitial()) {
    on<InitializeAREngine>(_onInitializeAREngine);
    on<SelectFurnitureForAR>(_onSelectFurnitureForAR);
    on<PlaneDetectedUpdate>(_onPlaneDetectedUpdate);
    on<PlaceFurnitureModel>(_onPlaceFurnitureModel);
    on<ClearPlacedModels>(_onClearPlacedModels);
  }

  Future<void> _onInitializeAREngine(
    InitializeAREngine event,
    Emitter<ARPlacementState> emit,
  ) async {
    emit(const ARPlacementLoading(message: 'Starting Camera & AR Engine...'));
    try {
      // Simulating camera initialization delay
      await Future.delayed(const Duration(milliseconds: 600));
      emit(const ARPlacementSuccess());
    } catch (e) {
      emit(ARPlacementError('Failed to initialize AR session: ${e.toString()}'));
    }
  }

  void _onSelectFurnitureForAR(
    SelectFurnitureForAR event,
    Emitter<ARPlacementState> emit,
  ) {
    final currentState = state;
    if (currentState is ARPlacementSuccess) {
      emit(currentState.copyWith(selectedFurniture: event.furniture));
    }
  }

  void _onPlaneDetectedUpdate(
    PlaneDetectedUpdate event,
    Emitter<ARPlacementState> emit,
  ) {
    final currentState = state;
    if (currentState is ARPlacementSuccess) {
      emit(currentState.copyWith(isPlaneDetected: event.isDetected));
    }
  }

  Future<void> _onPlaceFurnitureModel(
    PlaceFurnitureModel event,
    Emitter<ARPlacementState> emit,
  ) async {
    final currentState = state;
    if (currentState is ARPlacementSuccess) {
      final selectedFurniture = currentState.selectedFurniture;
      if (selectedFurniture == null) {
        emit(const ARPlacementError('No furniture model selected for placement.'));
        return;
      }

      // Transition to Loading state to simulate model downloading/loading
      emit(ARPlacementLoading(message: 'Loading 3D model: ${selectedFurniture.name}...'));
      
      try {
        // Simulating GLB parsing/loading delay
        await Future.delayed(const Duration(milliseconds: 1000));
        
        final updatedAnchors = List<String>.from(currentState.placedAnchorIds)
          ..add(event.anchorId);
        
        emit(ARPlacementSuccess(
          selectedFurniture: selectedFurniture,
          isPlaneDetected: currentState.isPlaneDetected,
          placedAnchorIds: updatedAnchors,
        ));
      } catch (e) {
        emit(ARPlacementError('Failed to load 3D asset ${selectedFurniture.glbPath}: ${e.toString()}'));
      }
    }
  }

  void _onClearPlacedModels(
    ClearPlacedModels event,
    Emitter<ARPlacementState> emit,
  ) {
    final currentState = state;
    if (currentState is ARPlacementSuccess) {
      emit(currentState.copyWith(placedAnchorIds: []));
    }
  }
}
