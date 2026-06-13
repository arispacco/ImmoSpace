import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immospace/core/services/firebase_backend_service.dart';
import 'package:immospace/features/vr_tour/data/datasources/vr_tour_local_datasource.dart';
import 'package:immospace/features/vr_tour/data/repositories/vr_tour_repository_impl.dart';

class _UnavailableBackendService implements BackendService {
  @override
  bool get isAvailable => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<FirebaseFirestore?> firestore() async => null;
}

void main() {
  group('VrTourRepositoryImpl', () {
    late VrTourRepositoryImpl repository;

    setUp(() {
      repository = VrTourRepositoryImpl(
        localDatasource: VrTourLocalDatasource(),
        backend: _UnavailableBackendService(),
      );
    });

    test('falls back to the local initial room when Firebase is unavailable',
        () async {
      final room = await repository.fetchInitialRoom();

      expect(room, isNotNull);
      expect(room!.id, 'living_room');
      expect(room.name, 'Elegant Living Room');
    });

    test('returns null for missing fallback rooms', () async {
      final room = await repository.getRoomById('missing_room');

      expect(room, isNull);
    });
  });
}
