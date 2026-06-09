import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/furniture.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadFurnitureList>(_onLoadFurnitureList);
  }

  Future<void> _onLoadFurnitureList(
    LoadFurnitureList event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      // Simulating network or database latency
      await Future.delayed(const Duration(milliseconds: 800));

      final mockFurniture = [
        const Furniture(
          id: '1',
          name: 'Modern Sofa',
          category: 'Living Room',
          glbPath: 'assets/models/sofa.glb',
        ),
        const Furniture(
          id: '2',
          name: 'Minimalist Chair',
          category: 'Dining Room',
          glbPath: 'assets/models/chair.glb',
        ),
        const Furniture(
          id: '3',
          name: 'Nordic Table',
          category: 'Office',
          glbPath: 'assets/models/table.glb',
        ),
        const Furniture(
          id: '4',
          name: 'Futuristic Lamp',
          category: 'Bedroom',
          glbPath: 'assets/models/lamp.glb',
        ),
        const Furniture(
          id: '5',
          name: 'Designer Sheen Chair',
          category: 'Living Room',
          glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/SheenChair/glTF-Binary/SheenChair.glb',
        ),
        const Furniture(
          id: '6',
          name: 'Antique Decor Camera',
          category: 'Office',
          glbPath: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/AntiqueCamera/glTF-Binary/AntiqueCamera.glb',
        ),
      ];

      emit(DashboardLoaded(mockFurniture));
    } catch (e) {
      emit(DashboardError('Failed to load furniture catalog: ${e.toString()}'));
    }
  }
}
