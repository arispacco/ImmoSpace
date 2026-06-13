import 'package:get_it/get_it.dart';

import '../services/firebase_backend_service.dart';

// Datasources
import '../../features/dashboard/data/datasources/furniture_local_datasource.dart';
import '../../features/vr_tour/data/datasources/vr_tour_local_datasource.dart';
import '../../features/ar_placement/data/datasources/ar_placement_local_datasource.dart';

// Repository interfaces
import '../../features/dashboard/domain/repositories/furniture_repository.dart';
import '../../features/vr_tour/domain/repositories/vr_tour_repository.dart';
import '../../features/ar_placement/domain/repositories/ar_placement_repository.dart';

// Repository implementations
import '../../features/dashboard/data/repositories/furniture_repository_impl.dart';
import '../../features/vr_tour/data/repositories/vr_tour_repository_impl.dart';
import '../../features/ar_placement/data/repositories/ar_placement_repository_impl.dart';

// BLoCs
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/vr_tour/presentation/bloc/vr_tour_bloc.dart';
import '../../features/ar_placement/presentation/bloc/ar_placement_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Registers all dependencies for the application.
/// Must be called before [runApp] in main.dart.
void setupServiceLocator() {
  // Core services
  sl.registerLazySingleton<BackendService>(() => FirebaseBackendService.instance);

  // ── Datasources (LazySingleton — one instance, created on first use) ──
  sl.registerLazySingleton(() => FurnitureLocalDatasource());
  sl.registerLazySingleton(() => VrTourLocalDatasource());
  sl.registerLazySingleton(() => ArPlacementLocalDatasource());

  // ── Repositories (LazySingleton — injected with datasources) ──
  sl.registerLazySingleton<FurnitureRepository>(
    () => FurnitureRepositoryImpl(localDatasource: sl(), backend: sl()),
  );
  sl.registerLazySingleton<VrTourRepository>(
    () => VrTourRepositoryImpl(localDatasource: sl(), backend: sl()),
  );
  sl.registerLazySingleton<ArPlacementRepository>(
    () => ArPlacementRepositoryImpl(
      localDatasource: sl(),
      furnitureRepository: sl(),
    ),
  );

  // ── BLoCs (Factory — new instance each time, injected with repositories) ──
  sl.registerFactory(() => DashboardBloc(repository: sl()));
  sl.registerFactory(() => VRTourBloc(repository: sl()));
  sl.registerFactory(() => ARPlacementBloc(repository: sl()));
}
