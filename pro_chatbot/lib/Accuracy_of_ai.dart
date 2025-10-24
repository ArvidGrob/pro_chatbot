import 'package:flutter/material.dart';
import 'login_page.dart';

class AccuracyOfAiPage extends StatelessWidget {
  const AccuracyOfAiPage({super.key});

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
                      // sorgt dafür, dass Inhalt mindestens "fast volle Bildschirmhöhe" hat
                      minHeight: c.maxHeight - 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Titel im selben Style
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

                        const SizedBox(height: 24),

                        // Abschnitt 1
                        Text(
                          'This section explores how accurate AI models are, '
                              'what factors affect their performance, and how we can '
                              'measure and improve their reliability.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Unterüberschrift
                        const Text(
                          'Evaluating AI Accuracy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Abschnitt 2
                        Text(
                          'AI accuracy depends heavily on the quality of training data, '
                              'the algorithm used, and the context in which the AI is applied.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Back-Button unten, genau wie auf TrainingPage
                        // Return button
                        Center(
                          child: _buildReturnButton(
                            buttonId: 'return',
                            iconPath: 'assets/images/return.png',
                            onTap: () {
                              print('Return tapped');
                            },
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
