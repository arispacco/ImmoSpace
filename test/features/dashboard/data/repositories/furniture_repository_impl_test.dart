import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immospace/core/services/firebase_backend_service.dart';
import 'package:immospace/features/dashboard/data/datasources/furniture_local_datasource.dart';
import 'package:immospace/features/dashboard/data/repositories/furniture_repository_impl.dart';

class _UnavailableBackendService implements BackendService {
  @override
  bool get isAvailable => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<FirebaseFirestore?> firestore() async => null;
}

void main() {
  group('FurnitureRepositoryImpl', () {
    late FurnitureRepositoryImpl repository;

    setUp(() {
      repository = FurnitureRepositoryImpl(
        localDatasource: FurnitureLocalDatasource(),
        backend: _UnavailableBackendService(),
      );
    });

    test('falls back to local furniture when Firebase is unavailable', () async {
      final furniture = await repository.getFurnitureList();

      expect(furniture, isNotEmpty);
      expect(furniture.first.id, '1');
      expect(furniture.first.name, 'Modern Sofa');
    });

    test('searches over fallback furniture data', () async {
      final furniture = await repository.searchFurniture('chair');

      expect(furniture, isNotEmpty);
      expect(
        furniture.every((item) => item.name.toLowerCase().contains('chair')),
        isTrue,
      );
    });
  });
}
