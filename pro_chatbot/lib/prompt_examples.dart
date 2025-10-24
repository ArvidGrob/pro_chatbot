import 'package:flutter/material.dart';
import 'login_page.dart';

class PromptExamplesPage extends StatelessWidget {
  const PromptExamplesPage({super.key});

  static const primary = Color(0xFF6464FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Hintergrund-Wellen wie auf TrainingPage
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 500),
                painter: WaveBackgroundPainter(),
              ),
            ),

            // Content wie auf TrainingPage (LayoutBuilder + ConstrainedBox!)
            LayoutBuilder(
              builder: (context, c) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: c.maxHeight - 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        const Text(
                          'Prompt Examples',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: primary,
                            letterSpacing: .5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Abschnitt 1
                        Text(
                          'Example text',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Subtitle
                        const Text(
                          'Subtitle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // example 2
                        Text(
                          'another example',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),


                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: primary,
                                elevation: 4,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
