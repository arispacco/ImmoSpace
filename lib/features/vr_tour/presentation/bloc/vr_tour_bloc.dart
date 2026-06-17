import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vr_room.dart';
import '../../domain/repositories/vr_tour_repository.dart';
import 'vr_tour_event.dart';
import 'vr_tour_state.dart';

class VRTourBloc extends Bloc<VRTourEvent, VRTourState> {
  final VrTourRepository _tourRepository;

  VRTourBloc({required VrTourRepository repository})
      : _tourRepository = repository,
        super(VRTourInitial()) {
    on<InitVRTour>(_onInitVRTour);
    on<NavigateToRoom>(_onNavigateToRoom);
    on<AddCustomRoom>(_onAddCustomRoom);
  }

  Future<void> _onInitVRTour(
    InitVRTour event,
    Emitter<VRTourState> emit,
  ) async {
    emit(VRTourLoading());
    try {
      final rooms = await _tourRepository.getRooms();
      final initialRoom = await _tourRepository.fetchInitialRoom();
      if (initialRoom != null) {
        emit(VRTourLoaded(initialRoom, rooms: _mergeRooms(rooms, initialRoom)));
      } else {
        emit(const VRTourError('Unable to load initial scene.'));
      }
    } catch (e) {
      emit(VRTourError('Error initializing VR tour: ${e.toString()}'));
    }
  }

  Future<void> _onNavigateToRoom(
    NavigateToRoom event,
    Emitter<VRTourState> emit,
  ) async {
    final previousState = state;
    final rooms = previousState is VRTourLoaded
        ? previousState.rooms
        : const <VRRoom>[];

    emit(VRTourLoading());
    // Simulate short transition load
    await Future.delayed(const Duration(milliseconds: 250));

    try {
      final nextRoom = await _tourRepository.getRoomById(event.roomId);
      if (nextRoom != null) {
        emit(VRTourLoaded(nextRoom, rooms: _mergeRooms(rooms, nextRoom)));
      } else {
        emit(VRTourError('Room ${event.roomId} not found.'));
      }
    } catch (e) {
      emit(VRTourError('Error navigating to room: ${e.toString()}'));
    }
  }

  Future<void> _onAddCustomRoom(
    AddCustomRoom event,
    Emitter<VRTourState> emit,
  ) async {
    emit(VRTourLoading());
    try {
      await _tourRepository.addRoom(event.room);
      final updatedRooms = await _tourRepository.getRooms();
      emit(VRTourLoaded(
        event.room,
        rooms: _mergeRooms(updatedRooms, event.room),
      ));
    } catch (e) {
      emit(VRTourError('Error adding room: ${e.toString()}'));
    }
  }

  List<VRRoom> _mergeRooms(List<VRRoom> rooms, VRRoom currentRoom) {
    final merged = <String, VRRoom>{
      for (final room in rooms) room.id: room,
      currentRoom.id: currentRoom,
    };
    return List.unmodifiable(merged.values);
  }
}
