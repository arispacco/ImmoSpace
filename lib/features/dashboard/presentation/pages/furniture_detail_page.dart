import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../../domain/entities/furniture.dart';

class FurnitureDetailPage extends StatefulWidget {
  final Furniture furniture;

  const FurnitureDetailPage({
    super.key,
    required this.furniture,
  });

  @override
  State<FurnitureDetailPage> createState() => _FurnitureDetailPageState();
}

class _FurnitureDetailPageState extends State<FurnitureDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  int _selectedColorIndex = 0;

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Obsidian Dark', 'color': const Color(0xFF1E1E2E), 'hex': '#1E1E2E'},
    {'name': 'Neon Cyan', 'color': const Color(0xFF00E6FF), 'hex': '#00E6FF'},
    {'name': 'Imperial Purple', 'color': const Color(0xFF8A84FF), 'hex': '#8A84FF'},
    {'name': 'Teal Ocean', 'color': const Color(0xFF03DAC6), 'hex': '#03DAC6'},
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _colorOptions[_selectedColorIndex]['color'] as Color;

    return Scaffold(
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
          child: Stack(
            children: [
              // Detail Content
              CustomScrollView(
                slivers: [
                  _buildHeader(context),
                  _buildVisualPreview(themeColor),
                  _buildProductInfo(themeColor),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)), // Space for sticky bottom button
                ],
              ),

              // Bottom floating CTA
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: _buildCTAButton(context, themeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GlassContainer(
              width: 44,
              height: 44,
              opacity: 0.1,
              borderRadius: BorderRadius.circular(12),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
            // Page Title
            const Text(
              'CUSTOMIZER',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            // Share button
            GlassContainer(
              width: 44,
              height: 44,
              opacity: 0.1,
              borderRadius: BorderRadius.circular(12),
              child: IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualPreview(Color themeColor) {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient glowing light behind model
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeColor.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),

            // Rotating wireframe background ring
            RotationTransition(
              turns: _rotationController,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3D Object Silhouette / Icon
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColor.withOpacity(0.08),
                    border: Border.all(
                      color: themeColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.chair_alt,
                    size: 110,
                    color: themeColor.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12, width: 0.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.crop_free, size: 10, color: Colors.white38),
                      SizedBox(width: 4),
                      Text(
                        'ROTATION SENSORS ACTIVE',
                        style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(Color themeColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.furniture.category.toUpperCase(),
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'USDZ / GLTF',
                    style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Name
            Text(
              widget.furniture.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Material/Color customization select
            const Text(
              'SELECT MATERIAL FINISH',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colorOptions.length,
                itemBuilder: (context, index) {
                  final option = _colorOptions[index];
                  final isSelected = _selectedColorIndex == index;
                  final color = option['color'] as Color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? themeColor : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Product Description
            const Text(
              'DESCRIPTION',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A beautifully minimal and sleek design combining organic curves with structural integrity. Specially optimized for spatial visualization and lighting projection within home layouts.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Technical Specifications (Specs Table)
            const Text(
              'TECHNICAL SPECIFICATIONS',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            GlassContainer(
              opacity: 0.04,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSpecRow('Dimensions', '84cm x 76cm x 92cm'),
                  const Divider(color: Colors.white10, height: 20),
                  _buildSpecRow('Material Finish', _colorOptions[_selectedColorIndex]['name'] as String),
                  const Divider(color: Colors.white10, height: 20),
                  _buildSpecRow('Draco Optimized', 'Yes (Mesh compression 82%)'),
                  const Divider(color: Colors.white10, height: 20),
                  _buildSpecRow('Cache Lifespan', 'Persistent disk space'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white30, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCTAButton(BuildContext context, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // Pass the customized furniture data directly to the AR route
          final customizedFurniture = widget.furniture.copyWith(
            name: '${widget.furniture.name} (${_colorOptions[_selectedColorIndex]['name']})',
          );
          context.push('/ar', extra: customizedFurniture);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: themeColor == const Color(0xFF1E1E2E) ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        icon: Icon(
          Icons.view_in_ar,
          color: themeColor == const Color(0xFF1E1E2E) ? Colors.white : Colors.black,
          size: 20,
        ),
        label: Text(
          'PROJECT IN AUGMENTED REALITY',
          style: TextStyle(
            color: themeColor == const Color(0xFF1E1E2E) ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
