import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:immospace/features/vr_tour/domain/entities/vr_room.dart';
import 'package:immospace/features/vr_tour/domain/repositories/vr_tour_repository.dart';
import 'package:immospace/features/vr_tour/presentation/bloc/vr_tour_bloc.dart';
import 'package:immospace/features/vr_tour/presentation/bloc/vr_tour_event.dart';
import 'package:immospace/features/vr_tour/presentation/bloc/vr_tour_state.dart';

class MockVrTourRepository extends Mock implements VrTourRepository {}

void main() {
  late MockVrTourRepository mockRepository;
  late VRTourBloc vrTourBloc;

  setUp(() {
    mockRepository = MockVrTourRepository();
    vrTourBloc = VRTourBloc(repository: mockRepository);
  });

  tearDown(() {
    vrTourBloc.close();
  });

  final testRoom1 = const VRRoom(
    id: 'living_room',
    name: 'Living Room',
    imagePath: 'living.jpg',
    hotspots: [],
  );

  final testRoom2 = const VRRoom(
    id: 'kitchen',
    name: 'Kitchen',
    imagePath: 'kitchen.jpg',
    hotspots: [],
  );

  group('VRTourBloc - InitVRTour', () {
    blocTest<VRTourBloc, VRTourState>(
      'emits [VRTourLoading, VRTourLoaded] when initial room loads successfully',
      build: () {
        when(() => mockRepository.getRooms())
            .thenAnswer((_) async => [testRoom1, testRoom2]);
        when(() => mockRepository.fetchInitialRoom())
            .thenAnswer((_) async => testRoom1);
        return vrTourBloc;
      },
      act: (bloc) => bloc.add(InitVRTour()),
      expect: () => [
        VRTourLoading(),
        VRTourLoaded(testRoom1, rooms: [testRoom1, testRoom2]),
      ],
    );

    blocTest<VRTourBloc, VRTourState>(
      'emits [VRTourLoading, VRTourError] when initial room fails to load',
      build: () {
        when(() => mockRepository.getRooms())
            .thenAnswer((_) async => [testRoom1, testRoom2]);
        when(() => mockRepository.fetchInitialRoom())
            .thenAnswer((_) async => null);
        return vrTourBloc;
      },
      act: (bloc) => bloc.add(InitVRTour()),
      expect: () => [
        VRTourLoading(),
        const VRTourError('Unable to load initial scene.'),
      ],
    );
  });

  group('VRTourBloc - NavigateToRoom', () {
    blocTest<VRTourBloc, VRTourState>(
      'emits [VRTourLoading, VRTourLoaded] when navigation target loads successfully',
      build: () {
        when(() => mockRepository.getRoomById('kitchen'))
            .thenAnswer((_) async => testRoom2);
        return vrTourBloc;
      },
      seed: () => VRTourLoaded(testRoom1, rooms: [testRoom1, testRoom2]),
      act: (bloc) => bloc.add(const NavigateToRoom('kitchen')),
      wait: const Duration(milliseconds: 300), // Account for transition delay in BLoC
      expect: () => [
        VRTourLoading(),
        VRTourLoaded(testRoom2, rooms: [testRoom1, testRoom2]),
      ],
    );

    blocTest<VRTourBloc, VRTourState>(
      'emits [VRTourLoading, VRTourError] when navigation target is not found',
      build: () {
        when(() => mockRepository.getRoomById('unknown'))
            .thenAnswer((_) async => null);
        return vrTourBloc;
      },
      act: (bloc) => bloc.add(const NavigateToRoom('unknown')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        VRTourLoading(),
        const VRTourError('Room unknown not found.'),
      ],
    );
  });
}
