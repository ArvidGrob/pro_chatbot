import 'package:flutter/material.dart';
import 'dart:math'; // Provides math constants/functions (used for pi in WaveBackgroundPainter)

class WaveBackgroundLayout extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const WaveBackgroundLayout({
    super.key,
    required this.child,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomPaint(
        painter: WaveBackgroundPainter(),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}

/// Custom Background (Waves at the bottom)
class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerY = size.height / 2;

    // Dark blue - (Top layer)
    paint.color = const Color(0xFF1E1EBF);
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.5, centerY - size.height * 0.08,
          size.width * 2, size.height),
      pi,
      pi,
      false,
      paint,
    );

    // Medium blue - (middle layer)
    paint.color = const Color(0xFF3B3BDE);
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.5, centerY - size.height * -0.10,
          size.width * 2, size.height),
      pi,
      pi,
      false,
      paint,
    );

    // Light blue - (bottom layer)
    paint.color = const Color(0xFF5959FF);
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.5, centerY - size.height * -0.25,
          size.width * 2, size.height),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
