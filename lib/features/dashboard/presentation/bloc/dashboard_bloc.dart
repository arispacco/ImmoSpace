import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< Updated upstream
import '../../domain/repositories/furniture_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FurnitureRepository _furnitureRepository;

  DashboardBloc({required FurnitureRepository repository})
      : _furnitureRepository = repository,
=======
import '../../../../core/services/asset_cache_service.dart';
import '../../data/models/furniture_model.dart';
import '../../domain/entities/furniture.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

const String _sofaModelUrl =
    'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/GlamVelvetSofa/glTF-Binary/GlamVelvetSofa.glb';
const String _chairModelUrl =
    'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ChairDamaskPurplegold/glTF-Binary/ChairDamaskPurplegold.glb';
const String _tableModelUrl =
    'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ClearcoatWicker/glTF-Binary/ClearcoatWicker.glb';
const String _lampModelUrl =
    'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/IridescenceLamp/glTF-Binary/IridescenceLamp.glb';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FurnitureRepository _furnitureRepository;

  DashboardBloc({FurnitureRepository? furnitureRepository})
      : _furnitureRepository =
            furnitureRepository ?? FirestoreFurnitureRepository(),
>>>>>>> Stashed changes
        super(DashboardInitial()) {
    on<LoadFurnitureList>(_onLoadFurnitureList);
    on<SearchFurniture>(_onSearchFurniture);
  }

  Future<void> _onLoadFurnitureList(
    LoadFurnitureList event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
<<<<<<< Updated upstream
      final furniture = await _furnitureRepository.getFurnitureList();
=======
      final furniture = await _furnitureRepository.fetchFurniture();
>>>>>>> Stashed changes
      emit(DashboardLoaded(furniture));
    } catch (e) {
      emit(DashboardError('Failed to load furniture catalog: ${e.toString()}'));
    }
  }

  Future<void> _onSearchFurniture(
    SearchFurniture event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      var furniture = await _furnitureRepository.getFurnitureList();

      // Filter by query (name search)
      if (event.query.isNotEmpty) {
        final query = event.query.toLowerCase();
        furniture = furniture
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
      }

      // Filter by category (if specified and not "All")
      if (event.category.isNotEmpty && event.category != 'All') {
        furniture = furniture
            .where((item) => item.category.toLowerCase() == event.category.toLowerCase())
            .toList();
      }

      emit(DashboardLoaded(furniture));
    } catch (e) {
      emit(DashboardError('Failed to filter furniture catalog: ${e.toString()}'));
    }
  }
}

abstract class FurnitureRepository {
  Future<List<Furniture>> fetchFurniture();
}

class FirestoreFurnitureRepository implements FurnitureRepository {
  FirestoreFurnitureRepository({
    FirebaseBackendService? backend,
  }) : _backend = backend ?? FirebaseBackendService.instance;

  final FirebaseBackendService _backend;

  @override
  Future<List<Furniture>> fetchFurniture() async {
    final firestore = await _backend.firestore();
    if (firestore == null) {
      return _fallbackFurniture;
    }

    try {
      final snapshot = await firestore.collection('furniture').get();
      final documents = snapshot.docs.where(_isActiveFurniture).toList()
        ..sort(_compareFurnitureDocuments);

      final furniture = documents
          .map(FurnitureModel.fromFirestore)
          .where((item) => item.name.isNotEmpty && item.glbPath.isNotEmpty)
          .toList(growable: false);

      if (furniture.isEmpty) {
        return _fallbackFurniture;
      }
      return furniture;
    } on FirebaseException catch (error) {
      debugPrint('Firestore furniture load failed: ${error.message}');
      return _fallbackFurniture;
    } catch (error) {
      debugPrint('Furniture repository failed: $error');
      return _fallbackFurniture;
    }
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

const List<Furniture> _fallbackFurniture = [
  Furniture(
    id: '1',
    name: 'Modern Sofa',
    category: 'Living Room',
    glbPath: _sofaModelUrl,
  ),
  Furniture(
    id: '2',
    name: 'Minimalist Chair',
    category: 'Dining Room',
    glbPath: _chairModelUrl,
  ),
  Furniture(
    id: '3',
    name: 'Nordic Table',
    category: 'Office',
    glbPath: _tableModelUrl,
  ),
  Furniture(
    id: '4',
    name: 'Futuristic Lamp',
    category: 'Bedroom',
    glbPath: _lampModelUrl,
  ),
  Furniture(
    id: '5',
    name: 'Designer Sheen Chair',
    category: 'Living Room',
    glbPath:
        'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/SheenChair/glTF-Binary/SheenChair.glb',
  ),
  Furniture(
    id: '6',
    name: 'Antique Decor Camera',
    category: 'Office',
    glbPath:
        'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/AntiqueCamera/glTF-Binary/AntiqueCamera.glb',
  ),
];
