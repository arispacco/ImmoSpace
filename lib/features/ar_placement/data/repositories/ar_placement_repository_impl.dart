import '../../../dashboard/domain/entities/furniture.dart';
import '../../../dashboard/domain/repositories/furniture_repository.dart';
import '../../domain/repositories/ar_placement_repository.dart';
import '../datasources/ar_placement_local_datasource.dart';

/// Concrete implementation of [ArPlacementRepository] delegating to [FurnitureRepository]
/// and falling back to local datasource if needed.
class ArPlacementRepositoryImpl implements ArPlacementRepository {
  final ArPlacementLocalDatasource localDatasource;
  final FurnitureRepository furnitureRepository;

  const ArPlacementRepositoryImpl({
    required this.localDatasource,
    required this.furnitureRepository,
  });

  @override
  Future<List<Furniture>> getAvailableFurniture() {
    return furnitureRepository.getFurnitureList();
  }

  @override
  Future<String> getModelUrl(String furnitureId) async {
    try {
      final list = await getAvailableFurniture();
      final item = list.firstWhere(
        (f) => f.id == furnitureId,
        orElse: () => throw Exception('Model not found in catalogue'),
      );
      return item.glbPath;
    } catch (_) {
      return localDatasource.getModelUrl(furnitureId);
    }
  }
}
