import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadarScanner extends StatefulWidget {
  final String statusText;
  final Color themeColor;

  const RadarScanner({
    super.key,
    this.statusText = 'SCANNING FOR SURFACES...',
    this.themeColor = const Color(0xFF00E6FF),
  });

  @override
  State<RadarScanner> createState() => _RadarScannerState();
}

class _RadarScannerState extends State<RadarScanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
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
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _RadarPainter(
                  rotationAngle: _controller.value * 2 * math.pi,
                  pulseValue: (math.sin(_controller.value * 2 * math.pi) + 1) / 2,
                  themeColor: widget.themeColor,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double opacity = 0.5 + 0.5 * math.sin(_controller.value * 4 * math.pi);
            return Text(
              widget.statusText,
              style: TextStyle(
                color: widget.themeColor.withOpacity(opacity),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                shadows: [
                  Shadow(
                    color: widget.themeColor.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double rotationAngle;
  final double pulseValue;
  final Color themeColor;

  _RadarPainter({
    required this.rotationAngle,
    required this.pulseValue,
    required this.themeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = themeColor.withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = themeColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // 1. Draw concentric grid circles
    canvas.drawCircle(center, radius * 0.3, basePaint);
    canvas.drawCircle(center, radius * 0.6, basePaint);
    canvas.drawCircle(center, radius * 0.9, basePaint);

    // 2. Draw crosshairs
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), basePaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), basePaint);

    // 3. Draw dashed outer circle
    const int dashCount = 30;
    const double dashLength = 6.0;
    final double circumference = 2 * math.pi * radius;
    final double spaceLength = (circumference / dashCount) - dashLength;
    double currentAngle = rotationAngle;

    for (int i = 0; i < dashCount; i++) {
      final double startX = center.dx + radius * math.cos(currentAngle);
      final double startY = center.dy + radius * math.sin(currentAngle);
      currentAngle += (dashLength / radius);
      final double endX = center.dx + radius * math.cos(currentAngle);
      final double endY = center.dy + radius * math.sin(currentAngle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), dashPaint);
      currentAngle += (spaceLength / radius);
    }

    // 4. Draw rotating sweeping arc
    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          themeColor.withOpacity(0.3),
          themeColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final sweepPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius * 0.9),
        rotationAngle,
        math.pi / 3, // 60 degrees sweep
        false,
      )
      ..close();
    canvas.drawPath(sweepPath, sweepPaint);

    // Draw the bright leading edge of the sweep
    final leadPaint = Paint()
      ..color = themeColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.9 * math.cos(rotationAngle + math.pi / 3),
        center.dy + radius * 0.9 * math.sin(rotationAngle + math.pi / 3),
      ),
      leadPaint,
    );

    // 5. Draw pulsing corner target brackets
    final bracketPaint = Paint()
      ..color = themeColor.withOpacity(0.6 + 0.4 * pulseValue)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final double bSize = 15.0; // bracket arm length
    final double offset = radius * 0.95; // distance from center

    // Top-Left Bracket
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - offset + bSize, center.dy - offset)
        ..lineTo(center.dx - offset, center.dy - offset)
        ..lineTo(center.dx - offset, center.dy - offset + bSize),
      bracketPaint,
    );

    // Top-Right Bracket
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + offset - bSize, center.dy - offset)
        ..lineTo(center.dx + offset, center.dy - offset)
        ..lineTo(center.dx + offset, center.dy - offset + bSize),
      bracketPaint,
    );

    // Bottom-Left Bracket
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - offset + bSize, center.dy + offset)
        ..lineTo(center.dx - offset, center.dy + offset)
        ..lineTo(center.dx - offset, center.dy + offset - bSize),
      bracketPaint,
    );

    // Bottom-Right Bracket
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + offset - bSize, center.dy + offset)
        ..lineTo(center.dx + offset, center.dy + offset)
        ..lineTo(center.dx + offset, center.dy + offset - bSize),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle || oldDelegate.pulseValue != pulseValue;
  }
}
