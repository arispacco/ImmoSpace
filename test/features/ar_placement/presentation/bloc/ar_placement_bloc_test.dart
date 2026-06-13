import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:immospace/features/dashboard/domain/entities/furniture.dart';
import 'package:immospace/features/ar_placement/domain/repositories/ar_placement_repository.dart';
import 'package:immospace/features/ar_placement/presentation/bloc/ar_placement_bloc.dart';
import 'package:immospace/features/ar_placement/presentation/bloc/ar_placement_event.dart';
import 'package:immospace/features/ar_placement/presentation/bloc/ar_placement_state.dart';

class MockArPlacementRepository extends Mock implements ArPlacementRepository {}

void main() {
  late MockArPlacementRepository mockRepository;
  late ARPlacementBloc arPlacementBloc;

  setUp(() {
    mockRepository = MockArPlacementRepository();
    arPlacementBloc = ARPlacementBloc(repository: mockRepository);
  });

  tearDown(() {
    arPlacementBloc.close();
  });

  final testFurniture = [
    const Furniture(id: '1', name: 'Sofa', category: 'Living Room', glbPath: 'sofa.glb'),
  ];

  group('ARPlacementBloc - InitializeAREngine', () {
    blocTest<ARPlacementBloc, ARPlacementState>(
      'emits [ARPlacementLoading, ARPlacementSuccess] on successful load',
      build: () {
        when(() => mockRepository.getAvailableFurniture())
            .thenAnswer((_) async => testFurniture);
        return arPlacementBloc;
      },
      act: (bloc) => bloc.add(InitializeAREngine()),
      wait: const Duration(milliseconds: 700), // Account for simulated delay
      expect: () => [
        const ARPlacementLoading(message: 'Starting Camera & AR Engine...'),
        ARPlacementSuccess(availableFurniture: testFurniture),
      ],
    );

    blocTest<ARPlacementBloc, ARPlacementState>(
      'selects initial furniture after available furniture loads',
      build: () {
        when(() => mockRepository.getAvailableFurniture())
            .thenAnswer((_) async => testFurniture);
        return arPlacementBloc;
      },
      act: (bloc) => bloc.add(
        InitializeAREngine(initialFurniture: testFurniture[0]),
      ),
      wait: const Duration(milliseconds: 700),
      expect: () => [
        const ARPlacementLoading(message: 'Starting Camera & AR Engine...'),
        ARPlacementSuccess(
          availableFurniture: testFurniture,
          selectedFurniture: testFurniture[0],
        ),
      ],
    );

    blocTest<ARPlacementBloc, ARPlacementState>(
      'emits [ARPlacementLoading, ARPlacementError] on repository failure',
      build: () {
        when(() => mockRepository.getAvailableFurniture())
            .thenThrow(Exception('Camera permission denied'));
        return arPlacementBloc;
      },
      act: (bloc) => bloc.add(InitializeAREngine()),
      expect: () => [
        const ARPlacementLoading(message: 'Starting Camera & AR Engine...'),
        const ARPlacementError('Failed to initialize AR session: Exception: Camera permission denied'),
      ],
    );
  });

  group('ARPlacementBloc - Selection & Updates', () {
    blocTest<ARPlacementBloc, ARPlacementState>(
      'updates selectedFurniture on SelectFurnitureForAR',
      build: () => arPlacementBloc,
      seed: () => ARPlacementSuccess(availableFurniture: testFurniture),
      act: (bloc) => bloc.add(SelectFurnitureForAR(testFurniture[0])),
      expect: () => [
        ARPlacementSuccess(
          availableFurniture: testFurniture,
          selectedFurniture: testFurniture[0],
        ),
      ],
    );

    blocTest<ARPlacementBloc, ARPlacementState>(
      'updates plane detection status on PlaneDetectedUpdate',
      build: () => arPlacementBloc,
      seed: () => ARPlacementSuccess(availableFurniture: testFurniture),
      act: (bloc) => bloc.add(const PlaneDetectedUpdate(true)),
      expect: () => [
        ARPlacementSuccess(
          availableFurniture: testFurniture,
          isPlaneDetected: true,
        ),
      ],
    );
  });

  group('ARPlacementBloc - Place & Clear', () {
    blocTest<ARPlacementBloc, ARPlacementState>(
      'emits loading then places model successfully',
      build: () => arPlacementBloc,
      seed: () => ARPlacementSuccess(
        availableFurniture: testFurniture,
        selectedFurniture: testFurniture[0],
        isPlaneDetected: true,
      ),
      act: (bloc) => bloc.add(const PlaceFurnitureModel('anchor_123')),
      wait: const Duration(milliseconds: 1100), // Account for model loading delay
      expect: () => [
        const ARPlacementLoading(message: 'Loading 3D model: Sofa...'),
        ARPlacementSuccess(
          availableFurniture: testFurniture,
          selectedFurniture: testFurniture[0],
          isPlaneDetected: true,
          placedAnchorIds: const ['anchor_123'],
        ),
      ],
    );

    blocTest<ARPlacementBloc, ARPlacementState>(
      'clears all placed anchors on ClearPlacedModels',
      build: () => arPlacementBloc,
      seed: () => ARPlacementSuccess(
        availableFurniture: testFurniture,
        selectedFurniture: testFurniture[0],
        isPlaneDetected: true,
        placedAnchorIds: const ['anchor_123'],
      ),
      act: (bloc) => bloc.add(ClearPlacedModels()),
      expect: () => [
        ARPlacementSuccess(
          availableFurniture: testFurniture,
          selectedFurniture: testFurniture[0],
          isPlaneDetected: true,
          placedAnchorIds: const [],
        ),
      ],
    );
  });
}
