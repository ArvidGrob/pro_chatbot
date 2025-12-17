import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'settings_page_hulp.dart';
import 'help_question_1.dart';
import 'help_question_2.dart';
import 'help_question_3.dart';
import 'help_question_4.dart';
import 'help_question_5.dart';
import 'help_question_6.dart';
import 'help_question_7.dart';
import 'help_question_8.dart';
import 'help_question_9.dart';
import 'help_question_10.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            // Scrollable content in background
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 110.0),
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
                            baseColor: themeManager.getContainerColor(0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion1(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question2',
                            text: 'Hoe verander je je stem?',
                            baseColor: themeManager.getContainerColor(1),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion2(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question3',
                            text: 'Hoe importeer ik een bestand in de chat?',
                            baseColor: themeManager.getContainerColor(2),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion3(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question4',
                            text: 'Hoe wijzig ik mijn wachtwoord?',
                            baseColor: themeManager.getContainerColor(3),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion4(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question5',
                            text:
                                'Hoe verwijder ik een\ngesprek uit de geschiedenis?',
                            baseColor: themeManager.getContainerColor(4),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion5(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question6',
                            text: 'Hoe neem ik contact op\nmet ondersteuning?',
                            baseColor: themeManager.getContainerColor(5),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion6(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question7',
                            text:
                                'Hoe werk ik met de\nspraak-naar-tekst functie?',
                            baseColor: themeManager.getContainerColor(0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion7(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question8',
                            text:
                                'Wat is de Training-sectie en\nhoe gebruik ik deze?',
                            baseColor: themeManager.getContainerColor(1),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion8(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question9',
                            text: 'Hoe wijzig ik mijn naam\nin mijn profiel?',
                            baseColor: themeManager.getContainerColor(2),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion9(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildQuestion(
                            themeManager,
                            questionId: 'question10',
                            text: 'Welke bestandsformaten\nkan ik uploaden?',
                            baseColor: themeManager.getContainerColor(3),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpQuestion10(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Return button fixed at bottom in foreground
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
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
              ),
            ),
          ],
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
    required VoidCallback onTap,
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
          onTap();
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
