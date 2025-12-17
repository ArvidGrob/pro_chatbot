import 'package:flutter/material.dart';
import 'getting_started.dart';
import 'how_it_works.dart';
import 'prompt_examples.dart';
import 'best_practices.dart';
import 'limitations.dart';
import 'accuracy_of_ai.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TrainingPage(),
      ),
    ),
  );
}

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Title
                  const Text(
                    'Training',
                    style: TextStyle(
                      color: Color(0xFF2323AD),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  _buildButton(
                    buttonId: 'getting_started',
                    label: 'Getting Started',
                    color: themeManager.getContainerColor(0),
                    pressedColor: themeManager.getSecondaryContainerColor(0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GettingStarted(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    buttonId: 'how_it_works',
                    label: 'How it Works',
                    color: themeManager.getContainerColor(1),
                    pressedColor: themeManager.getSecondaryContainerColor(1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HowItWorks(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    buttonId: 'prompt_examples',
                    label: 'Prompt Examples',
                    color: themeManager.getContainerColor(2),
                    pressedColor: themeManager.getSecondaryContainerColor(2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PromptExamples(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    buttonId: 'best_practices',
                    label: 'Best Practices',
                    color: themeManager.getContainerColor(3),
                    pressedColor: themeManager.getSecondaryContainerColor(3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BestPractices(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    buttonId: 'limitations',
                    label: 'Limitations',
                    color: themeManager.getContainerColor(4),
                    pressedColor: themeManager.getSecondaryContainerColor(4),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Limitations(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    buttonId: 'accuracy_of_ai',
                    label: 'Accuracy of Ai',
                    color: themeManager.getContainerColor(5),
                    pressedColor: themeManager.getSecondaryContainerColor(5),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccuracyOfAi(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Return button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/return.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String buttonId,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color pressedColor,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor = isPressed ? pressedColor : color;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedButton = buttonId;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressedButton = '';
        });
        onTap();
      },
      onTapCancel: () {
        setState(() {
          _pressedButton = '';
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 25.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
