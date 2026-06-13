import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/firebase_backend_service.dart';
import '../../domain/entities/vr_room.dart';
import '../../domain/repositories/vr_tour_repository.dart';
import '../datasources/vr_tour_local_datasource.dart';
import '../models/vr_room_model.dart';

/// Concrete implementation of [VrTourRepository] backed by Firestore and Local datasource fallback.
class VrTourRepositoryImpl implements VrTourRepository {
  final VrTourLocalDatasource localDatasource;
  final BackendService _backend;

  VrTourRepositoryImpl({
    required this.localDatasource,
    BackendService? backend,
  }) : _backend = backend ?? FirebaseBackendService.instance;

  static const String _collectionName = 'vrRooms';
  static const String _fallbackInitialRoomId = 'living_room';

  @override
  Future<List<VRRoom>> getRooms() async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      debugPrint('Firestore not available, using local datasource fallback for getRooms');
      return localDatasource.getRooms();
    }

    try {
      final snapshot = await firestore.collection(_collectionName).get();
      final rooms = snapshot.docs
          .map(VRRoomModel.fromFirestore)
          .where((r) => r.name.isNotEmpty && r.imagePath.isNotEmpty)
          .toList();

      if (rooms.isEmpty) {
        return localDatasource.getRooms();
      }
      return rooms;
    } catch (e) {
      debugPrint('Firestore getRooms failed: $e, using local fallback');
      return localDatasource.getRooms();
    }
  }

  @override
  Future<VRRoom?> getRoomById(String id) async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      debugPrint('Firestore not available, using local datasource fallback for getRoomById');
      return _localFallbackRoom(id);
    }

    try {
      final document = await firestore.collection(_collectionName).doc(id).get();
      if (document.exists) {
        return VRRoomModel.fromFirestore(document);
      }
      return _localFallbackRoom(id);
    } on FirebaseException catch (error) {
      debugPrint('Firestore VR room load failed: ${error.message}, using local fallback');
      return _localFallbackRoom(id);
    } catch (error) {
      debugPrint('VR room repository failed: $error, using local fallback');
      return _localFallbackRoom(id);
    }
  }

  @override
  Future<VRRoom?> fetchInitialRoom() async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      debugPrint('Firestore not available, using local datasource fallback for fetchInitialRoom');
      return _localFallbackRoom(_fallbackInitialRoomId);
    }

    try {
      final initialSnapshot = await firestore
          .collection(_collectionName)
          .where('isInitial', isEqualTo: true)
          .limit(1)
          .get();

      if (initialSnapshot.docs.isNotEmpty) {
        return VRRoomModel.fromFirestore(initialSnapshot.docs.first);
      }

      final fallbackDocument = await firestore
          .collection(_collectionName)
          .doc(_fallbackInitialRoomId)
          .get();
      if (fallbackDocument.exists) {
        return VRRoomModel.fromFirestore(fallbackDocument);
      }
      return _localFallbackRoom(_fallbackInitialRoomId);
    } on FirebaseException catch (error) {
      debugPrint('Firestore VR initial room load failed: ${error.message}, using local fallback');
      return _localFallbackRoom(_fallbackInitialRoomId);
    } catch (error) {
      debugPrint('VR initial room repository failed: $error, using local fallback');
      return _localFallbackRoom(_fallbackInitialRoomId);
    }
  }

  Future<VRRoom?> _localFallbackRoom(String id) async {
    try {
      return await localDatasource.getRoomById(id);
    } catch (_) {
      return null;
    }
  }
}
