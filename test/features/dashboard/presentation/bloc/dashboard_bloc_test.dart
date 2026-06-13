import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:immospace/features/dashboard/domain/entities/furniture.dart';
import 'package:immospace/features/dashboard/domain/repositories/furniture_repository.dart';
import 'package:immospace/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:immospace/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:immospace/features/dashboard/presentation/bloc/dashboard_state.dart';

class MockFurnitureRepository extends Mock implements FurnitureRepository {}

void main() {
  late MockFurnitureRepository mockRepository;
  late DashboardBloc dashboardBloc;

  setUp(() {
    mockRepository = MockFurnitureRepository();
    dashboardBloc = DashboardBloc(repository: mockRepository);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  final testFurniture = [
    const Furniture(id: '1', name: 'Sofa', category: 'Living Room', glbPath: 'sofa.glb'),
    const Furniture(id: '2', name: 'Chair', category: 'Dining Room', glbPath: 'chair.glb'),
  ];

  group('DashboardBloc - LoadFurnitureList', () {
    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when data is loaded successfully',
      build: () {
        when(() => mockRepository.getFurnitureList())
            .thenAnswer((_) async => testFurniture);
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadFurnitureList()),
      expect: () => [
        DashboardLoading(),
        DashboardLoaded(testFurniture),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardError] when load fails',
      build: () {
        when(() => mockRepository.getFurnitureList())
            .thenThrow(Exception('Network error'));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadFurnitureList()),
      expect: () => [
        DashboardLoading(),
        const DashboardError('Failed to load furniture catalog: Exception: Network error'),
      ],
    );
  });

  group('DashboardBloc - SearchFurniture', () {
    blocTest<DashboardBloc, DashboardState>(
      'filters furniture by query case-insensitively',
      build: () {
        when(() => mockRepository.getFurnitureList())
            .thenAnswer((_) async => testFurniture);
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const SearchFurniture(query: 'sofa')),
      expect: () => [
        DashboardLoading(),
        DashboardLoaded([testFurniture[0]]),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'filters furniture by category',
      build: () {
        when(() => mockRepository.getFurnitureList())
            .thenAnswer((_) async => testFurniture);
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const SearchFurniture(category: 'Dining Room')),
      expect: () => [
        DashboardLoading(),
        DashboardLoaded([testFurniture[1]]),
      ],
    );
  });
}
