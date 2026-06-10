import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/furniture.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  static const String _sofaModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/GlamVelvetSofa/glTF-Binary/GlamVelvetSofa.glb';
  static const String _chairModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ChairDamaskPurplegold/glTF-Binary/ChairDamaskPurplegold.glb';
  static const String _tableModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/ClearcoatWicker/glTF-Binary/ClearcoatWicker.glb';
  static const String _lampModelUrl =
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/IridescenceLamp/glTF-Binary/IridescenceLamp.glb';

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
          glbPath: _sofaModelUrl,
        ),
        const Furniture(
          id: '2',
          name: 'Minimalist Chair',
          category: 'Dining Room',
          glbPath: _chairModelUrl,
        ),
        const Furniture(
          id: '3',
          name: 'Nordic Table',
          category: 'Office',
          glbPath: _tableModelUrl,
        ),
        const Furniture(
          id: '4',
          name: 'Futuristic Lamp',
          category: 'Bedroom',
          glbPath: _lampModelUrl,
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
