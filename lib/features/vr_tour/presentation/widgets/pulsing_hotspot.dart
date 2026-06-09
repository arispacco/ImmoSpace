import 'package:flutter/material.dart';

class PulsingHotspot extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const PulsingHotspot({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  State<PulsingHotspot> createState() => _PulsingHotspotState();
}

class _PulsingHotspotState extends State<PulsingHotspot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing outer ring 1
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 50 * _controller.value,
                      height: 50 * _controller.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00E6FF).withOpacity(1.0 - _controller.value),
                          width: 2.0,
                        ),
                      ),
                    );
                  },
                ),
                // Pulsing outer ring 2 (delayed delay simulated by scale math)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double value = (_controller.value + 0.5) % 1.0;
                    return Container(
                      width: 50 * value,
                      height: 50 * value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00E6FF).withOpacity(1.0 - value),
                          width: 1.5,
                        ),
                      ),
                    );
                  },
                ),
                // Core static button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E6FF), Color(0xFF00A2FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E6FF).withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.navigation_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Glassmorphic label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF00E6FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
