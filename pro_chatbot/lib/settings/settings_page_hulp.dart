import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/api/user_provider.dart';
import '/models/user.dart';
import 'settings_page.dart';
import 'settings_page_hulp_2_1.dart';
import 'settings_page_hulp_2_2.dart';
import 'settings_page_hulp_2_3.dart';
import 'teacher_help_inbox_page.dart';
import 'student_help_responses_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPageHulp(),
      ),
    ),
  );
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
    final themeManager = Provider.of<ThemeManager>(context);

    // Essayer de récupérer le UserProvider de manière sûre
    UserProvider? userProvider;
    bool isTeacherOrAdmin = false;

    try {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      isTeacherOrAdmin = userProvider.currentUser != null &&
          userProvider.hasAnyRole([Role.teacher, Role.admin]);
    } catch (e) {
      // Si le provider n'est pas disponible, on considère que c'est un étudiant
      isTeacherOrAdmin = false;
    }

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hulp',
                    style: TextStyle(
                      color: Color(0xFF2A2AFF),
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

              // Mijn berichten (students)
              if (!isTeacherOrAdmin)
                _buildButton(
                  themeManager,
                  buttonId: 'mijn_berichten',
                  label: 'Mijn berichten',
                  color: themeManager.getContainerColor(0),
                  pressedColor: themeManager.getSecondaryContainerColor(0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentHelpResponsesPage(),
                    ),
                  ),
                ),
              if (!isTeacherOrAdmin) const SizedBox(height: 20),

              // Contact opnemen (students) of Berichten inbox (teachers/admin)
              _buildButton(
                themeManager,
                buttonId: 'contact',
                label: isTeacherOrAdmin ? 'Berichten inbox' : 'Contact opnemen',
                color: themeManager.getContainerColor(1),
                pressedColor: themeManager.getSecondaryContainerColor(1),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isTeacherOrAdmin
                        ? const TeacherHelpInboxPage()
                        : const SettingsPageHulp22(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Veelgestelde vragen
              _buildButton(
                themeManager,
                buttonId: 'veelgestelde',
                label: 'Veelgestelde vragen',
                color: themeManager.getContainerColor(2),
                pressedColor: themeManager.getSecondaryContainerColor(2),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp21(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Appversie
              _buildButton(
                themeManager,
                buttonId: 'appversie',
                label: 'Appversie',
                color: themeManager.getContainerColor(3),
                pressedColor: themeManager.getSecondaryContainerColor(3),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp23(
                      title: 'Appversie',
                      content: '''
1.0.0  
Alle rechten voorbehouden © 2025.
''',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ontwikkelaar
              _buildButton(
                themeManager,
                buttonId: 'ontwikkelaar',
                label: 'Ontwikkelaar',
                color: themeManager.getContainerColor(4),
                pressedColor: themeManager.getSecondaryContainerColor(4),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp23(
                      title: 'Ontwikkelaar',
                      content: '''
Luminara AI™ — ontwikkeld door LUM.INC \n 
In samenwerking met het lectoraat van Hogeschool Windesheim.
''',
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Return button (consistent with SettingsPageThema)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
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

  /// Unified button builder for main and sub-buttons
  Widget _buildButton(
    ThemeManager themeManager, {
    required String buttonId,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color pressedColor,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor = isPressed ? pressedColor : color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = buttonId),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 80), () {
          setState(() => _pressedButton = '');
          onTap();
        });
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
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
