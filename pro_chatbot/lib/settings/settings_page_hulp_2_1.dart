import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'settings_page_hulp.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPageHulp21(),
      ),
    ),
  );
}

class SettingsPageHulp21 extends StatefulWidget {
  const SettingsPageHulp21({super.key});

  @override
  State<SettingsPageHulp21> createState() => _SettingsPageHulp21State();
}

class _SettingsPageHulp21State extends State<SettingsPageHulp21> {
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hulp',
                    style: TextStyle(
                      color: Color(0xFF6464FF),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/hulp_2.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Veelgestelde vragen title
              Text(
                'Veelgestelde vragen',
                style: TextStyle(
                  color: themeManager.subtitleTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Questions container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildQuestion(
                      themeManager,
                      questionId: 'question1',
                      text: 'Hoe gebruik je de app?',
                      baseColor: themeManager.getOptionSoftBlue(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuestion(
                      themeManager,
                      questionId: 'question2',
                      text: 'Hoe verander je je stem?',
                      baseColor: themeManager.getOptionBrightPink(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuestion(
                      themeManager,
                      questionId: 'question3',
                      text: 'Hoe importeer ik een bestand in de chat?',
                      baseColor: themeManager.getOptionBlazeOrange(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuestion(
                      themeManager,
                      questionId: 'question4',
                      text: 'Hoe wijzig ik mijn wachtwoord?',
                      baseColor: themeManager.getOptionYellowSea(),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Return button
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageHulp(),
                      ),
                    );
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
    );
  }

  /// Individual question button with dynamic baseColor
  Widget _buildQuestion(
    ThemeManager themeManager, {
    required String questionId,
    required String text,
    required Color baseColor,
  }) {
    bool isPressed = _pressedButton == questionId;
    Color buttonColor =
        themeManager.getButtonColor(baseColor, isPressed: isPressed);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = questionId),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 80), () {
          setState(() => _pressedButton = '');
          print('$questionId tapped');
        });
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: isPressed ? 6 : 8,
              offset: Offset(0, isPressed ? 4 : 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
