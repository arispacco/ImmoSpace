import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vr_room.dart';
import 'vr_tour_event.dart';
import 'vr_tour_state.dart';

class VRTourBloc extends Bloc<VRTourEvent, VRTourState> {
  // Mock rooms database
  static final Map<String, VRRoom> _mockRooms = {
    'living_room': const VRRoom(
      id: 'living_room',
      name: 'Elegant Living Room',
      imagePath: 'assets/images/living_room_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h1',
          targetRoomId: 'kitchen',
          latitude: 45.0,
          longitude: 0.0,
          label: 'Go to Kitchen',
        ),
      ],
    ),
    'kitchen': const VRRoom(
      id: 'kitchen',
      name: 'Modern Kitchen',
      imagePath: 'assets/images/kitchen_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h2',
          targetRoomId: 'living_room',
          latitude: -45.0,
          longitude: 0.0,
          label: 'Back to Living Room',
        ),
        VRHotspot(
          id: 'h3',
          targetRoomId: 'balcony',
          latitude: 120.0,
          longitude: -10.0,
          label: 'Step onto Balcony',
        ),
      ],
    ),
    'balcony': const VRRoom(
      id: 'balcony',
      name: 'Panoramic Balcony',
      imagePath: 'assets/images/balcony_360.jpg',
      hotspots: [
        VRHotspot(
          id: 'h4',
          targetRoomId: 'kitchen',
          latitude: -120.0,
          longitude: 10.0,
          label: 'Return to Kitchen',
        ),
      ],
    ),
  };

  VRTourBloc() : super(VRTourInitial()) {
    on<InitVRTour>(_onInitVRTour);
    on<NavigateToRoom>(_onNavigateToRoom);
  }

  void _onInitVRTour(InitVRTour event, Emitter<VRTourState> emit) {
    emit(VRTourLoading());
    final initialRoom = _mockRooms['living_room'];
    if (initialRoom != null) {
      emit(VRTourLoaded(initialRoom));
    } else {
      emit(const VRTourError('Unable to load initial scene.'));
    }
  }

  Future<void> _onNavigateToRoom(
    NavigateToRoom event,
    Emitter<VRTourState> emit,
  ) async {
    emit(VRTourLoading());
    // Simulate short transition load
    await Future.delayed(const Duration(milliseconds: 500));

    final nextRoom = _mockRooms[event.roomId];
    if (nextRoom != null) {
      emit(VRTourLoaded(nextRoom));
    } else {
      emit(VRTourError('Room ${event.roomId} not found.'));
    }
  }
}
