import 'package:flutter/material.dart';
import 'settings_page_hulp_2_1.dart';
import 'settings_page_hulp_2_2.dart';
import 'settings_page_hulp_2_3.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SettingsPageHulp(),
  ));
}

class SettingsPageHulp extends StatefulWidget {
  const SettingsPageHulp({super.key});

  @override
  State<SettingsPageHulp> createState() => _SettingsPageHulpState();
}

class _SettingsPageHulpState extends State<SettingsPageHulp> {
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

                // Veelgestelde vragen button
                _buildButton(
                  buttonId: 'veelgestelde',
                  label: 'Veelgestelde vragen',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageHulp21(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Contact opnemen button
                _buildButton(
                  buttonId: 'contact',
                  label: 'Contact opnemen',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageHulp22(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Over section - always expanded
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6464FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Over header (not clickable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 25.0,
                        ),
                        child: const Center(
                          child: Text(
                            'Over',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Separator
                      Container(
                        width: double.infinity,
                        height: 2.0,
                        color: Colors.white,
                      ),

                      // Appversie button
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _pressedButton = 'appversie';
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _pressedButton = '';
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPageHulp23(
                                title: 'Over',
                                content: '',
                              ),
                            ),
                          );
                        },
                        onTapCancel: () {
                          setState(() {
                            _pressedButton = '';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 25.0,
                          ),
                          decoration: BoxDecoration(
                            color: _pressedButton == 'appversie'
                                ? const Color(0xFF4545BD)
                                : const Color(0xFF6464FF),
                          ),
                          child: const Center(
                            child: Text(
                              'Appversie',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Separator
                      Container(
                        width: double.infinity,
                        height: 2.0,
                        color: Colors.white,
                      ),

                      // Ontwikkelaar button
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _pressedButton = 'ontwikkelaar';
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _pressedButton = '';
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPageHulp23(
                                title: 'Over',
                                content:
                                    'Bedankt voor het\ngebruiken van onze app!',
                              ),
                            ),
                          );
                        },
                        onTapCancel: () {
                          setState(() {
                            _pressedButton = '';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 25.0,
                          ),
                          decoration: BoxDecoration(
                            color: _pressedButton == 'ontwikkelaar'
                                ? const Color(0xFF4545BD)
                                : const Color(0xFF6464FF),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Ontwikkelaar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildButton({
    required String buttonId,
    required String label,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor =
        isPressed ? const Color(0xFF4545BD) : const Color(0xFF6464FF);

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
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
