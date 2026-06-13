import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../domain/entities/furniture.dart';
import '../../../../core/utils/integrity_verifier.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _dashboardBloc;
  final TextEditingController _searchController = TextEditingController();
  
  // Easter egg variables
  int _titleTapCount = 0;
  DateTime? _lastTitleTapTime;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = sl<DashboardBloc>()..add(LoadFurnitureList());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    if (IntegrityVerifier.verifySecretCode(text)) {
      // Clear the text box immediately to maintain discretion
      _searchController.clear();
      FocusScope.of(context).unfocus();
      
      // Trigger the authorship pop-up
      _triggerAuthorshipVerification();
    } else {
      _dashboardBloc.add(SearchFurniture(query: text));
    }
  }

  void _handleTitleTap() {
    final now = DateTime.now();
    if (_lastTitleTapTime == null || now.difference(_lastTitleTapTime!) > const Duration(seconds: 2)) {
      _titleTapCount = 1;
    } else {
      _titleTapCount++;
    }
    _lastTitleTapTime = now;

    if (_titleTapCount >= 7) {
      _titleTapCount = 0;
      _triggerAuthorshipVerification();
    }
  }

  void _triggerAuthorshipVerification() {
    IntegrityVerifier.showAuthorshipCertificate(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>.value(
      value: _dashboardBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF12121A),
                Color(0xFF1E1E2E),
                Color(0xFF0F0F16),
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildHeader(context),
                _buildSearchBar(context),
                _buildImmersiveShortcuts(context),
                _buildSectionTitle('Furniture Catalogue'),
                _buildFurnitureGrid(context),
                _buildWatermarkFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _handleTitleTap,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    'IMMOSPACE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Immersive Property Experiences',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA0A0B0),
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
            // Avatar with hidden long-press verification
            GestureDetector(
              onLongPress: _triggerAuthorshipVerification,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A84FF), Color(0xFF00E6FF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8A84FF).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 24,
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search furniture items...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white30),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImmersiveShortcuts(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildShortcutCard(
                context,
                title: '360° VR Tour',
                subtitle: 'Visit property virtually',
                icon: Icons.threed_rotation,
                gradientColors: [const Color(0xFF6C63FF), const Color(0xFF3B33C7)],
                onTap: () => context.push('/vr'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildShortcutCard(
                context,
                title: 'AR Placement',
                subtitle: 'Visualize furniture',
                icon: Icons.view_in_ar,
                gradientColors: [const Color(0xFF00F2FE), const Color(0xFF4FACFE)],
                onTap: () => context.push('/ar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 16.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFurnitureGrid(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A84FF)),
              ),
            ),
          );
        } else if (state is DashboardLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final furniture = state.furnitureList[index];
                  return _buildFurnitureCard(context, furniture);
                },
                childCount: state.furnitureList.length,
              ),
            ),
          );
        } else if (state is DashboardError) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildFurnitureCard(BuildContext context, Furniture furniture) {
    List<Color> cardGradient;
    switch (furniture.category) {
      case 'Living Room':
        cardGradient = [const Color(0xFF3A3D40), const Color(0xFF181A1B)];
        break;
      case 'Dining Room':
        cardGradient = [const Color(0xFF2C5364), const Color(0xFF0F2027)];
        break;
      case 'Office':
        cardGradient = [const Color(0xFF1D976C), const Color(0xFF11432E)];
        break;
      default:
        cardGradient = [const Color(0xFF654ea3), const Color(0xFFeaafc8)];
    }

    return GestureDetector(
      onTap: () {
        context.push('/detail', extra: furniture);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardGradient,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(
                          Icons.chair_alt_outlined,
                          size: 64,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      furniture.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      furniture.category,
                      style: const TextStyle(
                        color: Color(0xFFA0A0B0),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/ar', extra: furniture);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A84FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.view_in_ar, size: 16),
                        label: const Text(
                          'Project AR',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '.GLB',
                    style: TextStyle(
                      color: Color(0xFF00E6FF),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Subtle built-in production version metadata tag (the visual signature)
  Widget _buildWatermarkFooter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: GestureDetector(
            onDoubleTap: _triggerAuthorshipVerification,
            child: Text(
              'ImmoSpace v1.0.0-a.r.i.s.t.i.d.e',
              style: TextStyle(
                color: Colors.white.withOpacity(0.12),
                fontSize: 10,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
