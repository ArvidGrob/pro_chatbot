import 'package:flutter/material.dart';
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SettingsPageHulp21(),
  ));
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                const Text(
                  'Veelgestelde vragen',
                  style: TextStyle(
                    color: Color(0xFF2323AD),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Questions container with scrollbar
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 8.0,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Question 1
                            _buildQuestion(
                              questionId: 'question1',
                              text: 'Hoe gebruik je de app?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion1(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 2
                            _buildQuestion(
                              questionId: 'question2',
                              text: 'Hoe verander je je stem?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion2(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 3
                            _buildQuestion(
                              questionId: 'question3',
                              text: 'Hoe importeer ik een\nbestand in de chat?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion3(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 4
                            _buildQuestion(
                              questionId: 'question4',
                              text: 'Hoe wijzig ik mijn\nwachtwoord?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion4(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 5
                            _buildQuestion(
                              questionId: 'question5',
                              text:
                                  'Hoe verwijder ik een\ngesprek uit de geschiedenis?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion5(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 6
                            _buildQuestion(
                              questionId: 'question6',
                              text:
                                  'Hoe neem ik contact op\nmet ondersteuning?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion6(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 7
                            _buildQuestion(
                              questionId: 'question7',
                              text:
                                  'Hoe werk ik met de\nspraak-naar-tekst functie?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion7(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 8
                            _buildQuestion(
                              questionId: 'question8',
                              text:
                                  'Wat is de Training-sectie en\nhoe gebruik ik deze?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion8(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 9
                            _buildQuestion(
                              questionId: 'question9',
                              text: 'Hoe wijzig ik mijn naam\nin mijn profiel?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpQuestion9(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // Question 10
                            _buildQuestion(
                              questionId: 'question10',
                              text: 'Welke bestandsformaten\nkan ik uploaden?',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HelpQuestion10(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
    );
  }

  Widget _buildQuestion({
    required String questionId,
    required String text,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedButton == questionId;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedButton = questionId;
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
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: isPressed ? const Color(0xFFBBBBBB) : const Color(0xFFD9D9D9),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2323AD),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
