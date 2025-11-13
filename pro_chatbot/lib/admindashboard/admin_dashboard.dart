import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'package:pro_chatbot/admindashboard/addstudent.dart';
import 'package:pro_chatbot/admindashboard/teacher_overview.dart';
import 'student_overview.dart';
import 'class_overview.dart';
import '/api/user.dart';
import '/api/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminDashboard(),
      ),
    ),
  );
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
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
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
                primaryColor: themeManager.getOptionSoftBlue(),
                secondaryColor: themeManager.getSecondaryColor(
                    themeManager.getOptionSoftBlue(),
                    lightenAmount: 0.2),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StudentOverviewPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Docent button
              _buildDashboardButton(
                buttonId: 'docent',
                label: 'Docent',
                iconPath: 'assets/images/docent.png',
                primaryColor: themeManager.getOptionBrightPink(),
                secondaryColor: themeManager.getSecondaryColor(
                    themeManager.getOptionBrightPink(),
                    lightenAmount: 0.2),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherOverviewPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Beheer button
              _buildDashboardButton(
                buttonId: 'klas',
                label: 'Klas',
                iconPath: 'assets/images/beheer.png',
                primaryColor: themeManager.getOptionBlazeOrange(),
                secondaryColor: themeManager.getSecondaryColor(
                    themeManager.getOptionBlazeOrange(),
                    lightenAmount: 0.2),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ClassOverviewPage(),
                    ),
                  );
                },
              ),
              const Spacer(),

              // Return button
              Center(
                child: _buildReturnButton(
                  buttonId: 'return',
                  iconPath: 'assets/images/return.png',
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required String buttonId,
    required String label,
    required String iconPath,
    required Color primaryColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedButton == buttonId;
    final Color displayPrimary = isPressed
        ? ThemeManager().darkenColor(primaryColor, 0.25)
        : primaryColor;
    final Color displaySecondary = isPressed
        ? ThemeManager().darkenColor(secondaryColor, 0.25)
        : secondaryColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = buttonId),
      onTapUp: (_) {
        setState(() => _pressedButton = '');
        onTap();
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: displayPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
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
            Container(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                color: displaySecondary,
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
