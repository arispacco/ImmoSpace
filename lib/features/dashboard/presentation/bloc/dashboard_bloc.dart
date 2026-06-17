import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/furniture_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FurnitureRepository _furnitureRepository;

  DashboardBloc({required FurnitureRepository repository})
      : _furnitureRepository = repository,
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
      final furniture = await _furnitureRepository.getFurnitureList();
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
