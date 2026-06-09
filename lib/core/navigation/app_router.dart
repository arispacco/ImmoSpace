import 'package:go_router/go_router.dart';
import '../../features/dashboard/domain/entities/furniture.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/vr_tour/presentation/pages/vr_tour_page.dart';
import '../../features/ar_placement/presentation/pages/ar_placement_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/vr',
      name: 'vr_tour',
      builder: (context, state) => const VRTourPage(),
    ),
    GoRoute(
      path: '/ar',
      name: 'ar_placement',
      builder: (context, state) {
        final furniture = state.extra as Furniture?;
        return ARPlacementPage(selectedFurniture: furniture);
      },
    ),
  ],
);
