import 'package:flutter/material.dart';

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

                const SizedBox(height: 30),

                // Questions container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Question 1
                      _buildQuestion(
                        questionId: 'question1',
                        text: 'Hoe gebruik je de app?',
                        onTap: () {
                          print('Question 1 tapped');
                        },
                      ),

                      const SizedBox(height: 15),

                      // Question 2
                      _buildQuestion(
                        questionId: 'question2',
                        text: 'Hoe verander je je stem?',
                        onTap: () {
                          print('Question 2 tapped');
                        },
                      ),

                      const SizedBox(height: 15),

                      // Question 3
                      _buildQuestion(
                        questionId: 'question3',
                        text: 'Hoe importeer ik een\nbestand in de chat?',
                        onTap: () {
                          print('Question 3 tapped');
                        },
                      ),

                      const SizedBox(height: 15),

                      // Question 4
                      _buildQuestion(
                        questionId: 'question4',
                        text: 'Hoe wijzig ik mijn\nwachtwoord?',
                        onTap: () {
                          print('Question 4 tapped');
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

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
