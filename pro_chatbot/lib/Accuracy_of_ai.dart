import 'package:flutter/material.dart';
import 'login_page.dart';

class AccuracyOfAiPage extends StatelessWidget {
  const AccuracyOfAiPage({super.key});

  static const primary = Color(0xFF6464FF);
  static const fileNameTitle = 'Accuracy_of_ai.dart';

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
                    'Accuracy of AI',
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
