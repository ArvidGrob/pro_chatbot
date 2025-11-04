import 'package:flutter/material.dart';
import '../settings/settings_page.dart';
import '../admindashboard/admin_dashboard.dart';
import '../training/training_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const NavigationPage(),
  ));
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation title
                Center(
                  child: const Text(
                    'Navigation',
                    style: TextStyle(
                      color: Color(0xFF3B3B98),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Chat button (large, full width)
                _buildLargeButton(
                  buttonId: 'chat',
                  title: 'Chat',
                  iconPath: 'assets/images/chat.png',
                  onTap: () {
                    // TODO: Navigate to chat page
                    print('Chat pressed');
                  },
                ),

                const SizedBox(height: 20),

                // Training button (large, full width)
                _buildLargeButton(
                  buttonId: 'training',
                  title: 'Training',
                  iconPath: 'assets/images/training.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainingPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Bottom row with two smaller buttons
                Row(
                  children: [
                    // Instellingen button
                    Expanded(
                      child: _buildSmallButton(
                        buttonId: 'instellingen',
                        title: 'Instellingen',
                        iconPath: 'assets/images/settings.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Admin button
                    Expanded(
                      child: _buildSmallButton(
                        buttonId: 'admin',
                        title: 'Admin',
                        iconPath: 'assets/images/admin.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDashboard(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build large navigation button
  Widget _buildLargeButton({
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
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor, // Dynamic purple primary color
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Icon zone (right side with lighter color)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: secondaryColor, // Dynamic lighter color for icon
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

  // Build small navigation button
  Widget _buildSmallButton({
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
        height: 150,
        decoration: BoxDecoration(
          color: primaryColor, // Dynamic purple primary color
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Text zone (upper part)
            SizedBox(
              width: double.infinity,
              height: 70,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Icon zone (lower part with lighter color)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor, // Dynamic lighter color for icon
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      iconPath,
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
}
