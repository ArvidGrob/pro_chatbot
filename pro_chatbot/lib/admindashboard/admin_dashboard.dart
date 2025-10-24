import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AdminDashboard(),
  ));
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
                  'Admin dashboard',
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFF4242BD),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // Student button
                _buildDashboardButton(
                  buttonId: 'student',
                  label: 'Student',
                  iconPath: 'assets/images/student.png',
                  onTap: () {
                    print('Student tapped');
                  },
                ),

                const SizedBox(height: 25),

                // Docent button
                _buildDashboardButton(
                  buttonId: 'docent',
                  label: 'Docent',
                  iconPath: 'assets/images/docent.png',
                  onTap: () {
                    print('Docent tapped');
                  },
                ),

                const SizedBox(height: 25),

                // Beheer button
                _buildDashboardButton(
                  buttonId: 'beheer',
                  label: 'Beheer',
                  iconPath: 'assets/images/beheer.png',
                  onTap: () {
                    print('Beheer tapped');
                  },
                ),

                const Spacer(),

                // Return button
                Center(
                  child: _buildReturnButton(
                    buttonId: 'return',
                    iconPath: 'assets/images/return.png',
                    onTap: () {
                      Navigator.pop(context);
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

  Widget _buildDashboardButton({
    required String buttonId,
    required String label,
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
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Left side with label
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                  bottom: 20.0,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Right side with icon
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 80,
                  height: 80,
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
    required String buttonId,
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
