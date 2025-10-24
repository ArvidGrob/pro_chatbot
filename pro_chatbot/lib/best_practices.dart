import 'package:flutter/material.dart';
import 'login_page.dart';

class BestPracticesPage extends StatelessWidget {
  const BestPracticesPage({super.key});

  static const primary = Color(0xFF6464FF);
  static const fileNameTitle = 'best_practices.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 500),
                painter: WaveBackgroundPainter(),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: const [
                  SizedBox(height: 8),
                  const Text(
                    'Best Practices',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: primary,
                      letterSpacing: .5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
