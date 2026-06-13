import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/firebase_backend_service.dart';
import '../../domain/entities/furniture.dart';
import '../../domain/repositories/furniture_repository.dart';
import '../datasources/furniture_local_datasource.dart';
import '../models/furniture_model.dart';

/// Concrete implementation of [FurnitureRepository] backed by Firestore and Local datasource fallback.
class FurnitureRepositoryImpl implements FurnitureRepository {
  final FurnitureLocalDatasource localDatasource;
  final BackendService _backend;

  FurnitureRepositoryImpl({
    required this.localDatasource,
    BackendService? backend,
  }) : _backend = backend ?? FirebaseBackendService.instance;

  static const String _collectionName = 'furniture';

  @override
  Future<List<Furniture>> getFurnitureList() async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      debugPrint('Firestore not available, using local datasource fallback');
      return localDatasource.getFurnitureList();
    }

    try {
      final snapshot = await firestore.collection(_collectionName).get();
      final documents = snapshot.docs.where(_isActiveFurniture).toList()
        ..sort(_compareFurnitureDocuments);

      final list = documents
          .map(FurnitureModel.fromFirestore)
          .where((item) => item.name.isNotEmpty && item.glbPath.isNotEmpty)
          .toList(growable: false);

      if (list.isEmpty) {
        debugPrint('Firestore returned empty furniture list, using local fallback');
        return localDatasource.getFurnitureList();
      }
      return list;
    } on FirebaseException catch (error) {
      debugPrint('Firestore furniture load failed: ${error.message}, using local fallback');
      return localDatasource.getFurnitureList();
    } catch (error) {
      debugPrint('Furniture repository load failed: $error, using local fallback');
      return localDatasource.getFurnitureList();
    }
  }

  @override
  Future<List<Furniture>> searchFurniture(String query) async {
    if (query.isEmpty) {
      return getFurnitureList();
    }
    
    // First try to load the full list (from Firestore or local fallback)
    final allFurniture = await getFurnitureList();
    final lowerQuery = query.toLowerCase();
    
    return allFurniture
        .where((f) => f.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<Furniture>> getFurnitureByCategory(String category) async {
    if (category.isEmpty) {
      return getFurnitureList();
    }

    final allFurniture = await getFurnitureList();
    return allFurniture
        .where((f) => f.category == category)
        .toList();
  }

  bool _isActiveFurniture(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return document.data()['isActive'] != false;
  }

  int _compareFurnitureDocuments(
    QueryDocumentSnapshot<Map<String, dynamic>> left,
    QueryDocumentSnapshot<Map<String, dynamic>> right,
  ) {
    final leftOrder = _readSortOrder(left.data()['sortOrder']);
    final rightOrder = _readSortOrder(right.data()['sortOrder']);
    final orderComparison = leftOrder.compareTo(rightOrder);
    if (orderComparison != 0) {
      return orderComparison;
    }

    final leftName = _readString(left.data()['name'], fallback: left.id);
    final rightName = _readString(right.data()['name'], fallback: right.id);
    return leftName.compareTo(rightName);
  }

  int _readSortOrder(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 9999;
  }

  String _readString(Object? value, {String fallback = ''}) {
    final stringValue = value?.toString() ?? '';
    return stringValue.isEmpty ? fallback : stringValue;
  }
}
