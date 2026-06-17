import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/asset_cache_service.dart';
import '../../domain/entities/vr_room.dart';
import '../../domain/repositories/vr_tour_repository.dart';
import 'vr_tour_event.dart';
import 'vr_tour_state.dart';

class VRTourBloc extends Bloc<VRTourEvent, VRTourState> {
<<<<<<< Updated upstream
  final VrTourRepository _tourRepository;

  VRTourBloc({required VrTourRepository repository})
      : _tourRepository = repository,
=======
  final VRTourRepository _tourRepository;

  VRTourBloc({VRTourRepository? tourRepository})
      : _tourRepository = tourRepository ?? FirestoreVRTourRepository(),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
    final initialRoom = await _tourRepository.fetchInitialRoom();
    if (initialRoom != null) {
      emit(VRTourLoaded(initialRoom));
    } else {
      emit(const VRTourError('Unable to load initial scene.'));
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
    await Future.delayed(const Duration(milliseconds: 250));

    final nextRoom = await _tourRepository.fetchRoomById(event.roomId);
    if (nextRoom != null) {
      emit(VRTourLoaded(nextRoom));
    } else {
      emit(VRTourError('Room ${event.roomId} not found.'));
>>>>>>> Stashed changes
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

abstract class VRTourRepository {
  Future<VRRoom?> fetchInitialRoom();

  Future<VRRoom?> fetchRoomById(String roomId);
}

class FirestoreVRTourRepository implements VRTourRepository {
  FirestoreVRTourRepository({
    FirebaseBackendService? backend,
  }) : _backend = backend ?? FirebaseBackendService.instance;

  static const String _roomsCollection = 'vrRooms';
  static const String _fallbackInitialRoomId = 'living_room';

  final FirebaseBackendService _backend;

  @override
  Future<VRRoom?> fetchInitialRoom() async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      return _fallbackRooms[_fallbackInitialRoomId];
    }

    try {
      final initialSnapshot = await firestore
          .collection(_roomsCollection)
          .where('isInitial', isEqualTo: true)
          .limit(1)
          .get();

      if (initialSnapshot.docs.isNotEmpty) {
        final room = _roomFromDocument(initialSnapshot.docs.first);
        if (room != null) {
          return room;
        }
      }

      final fallbackDocument = await firestore
          .collection(_roomsCollection)
          .doc(_fallbackInitialRoomId)
          .get();
      return _roomFromDocument(fallbackDocument) ??
          _fallbackRooms[_fallbackInitialRoomId];
    } on FirebaseException catch (error) {
      debugPrint('Firestore VR initial room load failed: ${error.message}');
      return _fallbackRooms[_fallbackInitialRoomId];
    } catch (error) {
      debugPrint('VR initial room repository failed: $error');
      return _fallbackRooms[_fallbackInitialRoomId];
    }
  }

  @override
  Future<VRRoom?> fetchRoomById(String roomId) async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      return _fallbackRooms[roomId];
    }

    try {
      final document =
          await firestore.collection(_roomsCollection).doc(roomId).get();
      return _roomFromDocument(document) ?? _fallbackRooms[roomId];
    } on FirebaseException catch (error) {
      debugPrint('Firestore VR room load failed: ${error.message}');
      return _fallbackRooms[roomId];
    } catch (error) {
      debugPrint('VR room repository failed: $error');
      return _fallbackRooms[roomId];
    }
  }

  VRRoom? _roomFromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (!document.exists || data == null) {
      return null;
    }

    final imagePath = _readString(data['imagePath']);
    if (imagePath.isEmpty) {
      return null;
    }

    return VRRoom(
      id: _readString(data['id'], fallback: document.id),
      name: _readString(data['name'], fallback: document.id),
      imagePath: imagePath,
      hotspots: _readHotspots(data['hotspots']),
    );
  }

  List<VRHotspot> _readHotspots(Object? value) {
    if (value is! Iterable) {
      return const [];
    }

    return value.map(_hotspotFromValue).whereType<VRHotspot>().toList(
          growable: false,
        );
  }

  VRHotspot? _hotspotFromValue(Object? value) {
    if (value is! Map) {
      return null;
    }

    final data = Map<String, dynamic>.from(value);
    final id = _readString(data['id']);
    final targetRoomId = _readString(data['targetRoomId']);
    final label = _readString(data['label']);

    if (id.isEmpty || targetRoomId.isEmpty || label.isEmpty) {
      return null;
    }

    return VRHotspot(
      id: id,
      targetRoomId: targetRoomId,
      latitude: _readDouble(data['latitude']),
      longitude: _readDouble(data['longitude']),
      label: label,
    );
  }

  double _readDouble(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return 0;
  }

  String _readString(Object? value, {String fallback = ''}) {
    final stringValue = value?.toString() ?? '';
    return stringValue.isEmpty ? fallback : stringValue;
  }
}

const Map<String, VRRoom> _fallbackRooms = {
  'living_room': VRRoom(
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
  'kitchen': VRRoom(
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
  'balcony': VRRoom(
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
