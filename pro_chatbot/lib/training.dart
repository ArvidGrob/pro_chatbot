import 'package:flutter/material.dart';
import 'gettingstarted.dart';
import 'how_it_works.dart';
import 'prompt_examples.dart';
import 'best_practices.dart';
import 'Limitations.dart';
import 'Accuracy_of_ai.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Training',
      home: const TrainingPage(),
    );
  }
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  static const primary = Color(0xFF6464FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Backgroundwaves from loginpage
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 500),
                painter: WaveBackgroundPainter(),
              ),
            ),

            // Content
            LayoutBuilder(
              builder: (context, c) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight - 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Training',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: primary,
                            letterSpacing: .5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Buttons
                        _TrainingButton(
                          label: 'Getting Started',
                          onTap: () => _open(context, const GettingStartedPage()),
                        ),
                        const SizedBox(height: 14),
                        _TrainingButton(
                          label: 'How it Works',
                          onTap: () => _open(context, const HowItWorksPage()),
                        ),
                        const SizedBox(height: 14),
                        _TrainingButton(
                          label: 'Prompt Examples',
                          onTap: () => _open(context, const PromptExamplesPage()),
                        ),
                        const SizedBox(height: 14),
                        _TrainingButton(
                          label: 'Best Practices',
                          onTap: () => _open(context, const BestPracticesPage()),
                        ),
                        const SizedBox(height: 14),
                        _TrainingButton(
                          label: 'Limitations',
                          onTap: () => _open(context, const LimitationsPage()),
                        ),
                        const SizedBox(height: 14),
                        _TrainingButton(
                          label: 'Accuracy of AI',
                          onTap: () => _open(context, const AccuracyOfAiPage()),
                        ),

                        const SizedBox(height: 28),

                        // Back-Button unten
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
                              child: const Icon(Icons.arrow_back_rounded, size: 28),
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

  static void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}


class _TrainingButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TrainingButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8F8FFF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
