import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'settings_page.dart';
import 'settings_page_hulp_2_1.dart';
import 'settings_page_hulp_2_2.dart';
import 'settings_page_hulp_2_3.dart';

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

              // Veelgestelde vragen -> Soft Blue
              _buildButton(
                themeManager,
                buttonId: 'veelgestelde',
                label: 'Veelgestelde vragen',
                baseColor: themeManager.getOptionSoftBlue(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp21(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Contact opnemen -> Bright Pink
              _buildButton(
                themeManager,
                buttonId: 'contact',
                label: 'Contact opnemen',
                baseColor: themeManager.getOptionBrightPink(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp22(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Appversie -> Blaze Orange
              _buildButton(
                themeManager,
                buttonId: 'appversie',
                label: 'Appversie',
                baseColor: themeManager.getOptionBlazeOrange(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp23(
                      title: 'Appversie',
                      content: '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ontwikkelaar -> Yellow Sea
              _buildButton(
                themeManager,
                buttonId: 'ontwikkelaar',
                label: 'Ontwikkelaar',
                baseColor: themeManager.getOptionYellowSea(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPageHulp23(
                      title: 'Ontwikkelaar',
                      content: 'Bedankt voor het\ngebruiken van onze app!',
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
    required Color baseColor,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor =
        themeManager.getButtonColor(baseColor, isPressed: isPressed);

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
