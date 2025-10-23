import 'package:flutter/material.dart';
import 'settings_page_account.dart';
import 'settings_page_spraak.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SettingsPage(),
  ));
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                // Title
                const Text(
                  'Instellingen',
                  style: TextStyle(
                    color: Color(0xFF4242BD),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // Account button
                _buildSettingsButton(
                  buttonId: 'account',
                  title: 'Account',
                  iconPath: 'assets/images/account.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageAccount(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Spraak button
                _buildSettingsButton(
                  buttonId: 'spraak',
                  title: 'Spraak',
                  iconPath: 'assets/images/spraak.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageSpraak(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Thema button
                _buildSettingsButton(
                  buttonId: 'thema',
                  title: 'Thema',
                  iconPath: 'assets/images/thema.png',
                  onTap: () {
                    print('Thema tapped');
                  },
                ),

                const SizedBox(height: 30),

                // Hulp button
                _buildSettingsButton(
                  buttonId: 'hulp',
                  title: 'Hulp',
                  iconPath: 'assets/images/hulp.png',
                  onTap: () {
                    print('Hulp tapped');
                  },
                ),

                const Spacer(),

                // Return button
                Center(
                  child: _buildReturnButton(
                    iconPath: 'assets/images/return.png',
                    onTap: () {
                      print('Return tapped');
                    },
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

  Widget _buildSettingsButton({
    required String buttonId,
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color primaryColor =
        isPressed ? const Color(0xFF4545BD) : const Color(0xFF6464FF);
    Color secondaryColor =
        isPressed ? const Color(0xFF6D6DCA) : const Color(0xFF8989FF);

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
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text zone (left side)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Icon zone (right side with lighter color)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconPath,
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }
}
