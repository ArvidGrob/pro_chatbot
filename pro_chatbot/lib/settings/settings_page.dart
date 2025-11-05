import 'package:flutter/material.dart';
import 'settings_page_account.dart';
import 'settings_page_spraak.dart';
import 'settings_page_hulp.dart';
import 'settings_page_thema.dart';
import '/wave_background_layout.dart';
import '/theme_manager.dart';
import 'package:provider/provider.dart';
import '/navigation/navigation_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPage(),
      ),
    ),
  );
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
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Instellingen',
              style: TextStyle(
                color: Color(0xFF4242BD),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Account
            _buildSettingsButton(
              id: 'account',
              title: 'Account',
              iconPath: 'assets/images/account.png',
              color: themeManager.getOptionSoftBlue(),
              themeManager: themeManager,
              onTap: () => _navigateTo(context, const SettingsPageAccount()),
            ),
            const SizedBox(height: 30),

            // Spraak
            _buildSettingsButton(
              id: 'spraak',
              title: 'Spraak',
              iconPath: 'assets/images/spraak.png',
              color: themeManager.getOptionBrightPink(),
              themeManager: themeManager,
              onTap: () => _navigateTo(context, const SettingsPageSpraak()),
            ),
            const SizedBox(height: 30),

            // Thema
            _buildSettingsButton(
              id: 'thema',
              title: 'Thema',
              iconPath: 'assets/images/thema.png',
              color: themeManager.getOptionBlazeOrange(),
              themeManager: themeManager,
              onTap: () => _navigateTo(context, const SettingsPageThema()),
            ),
            const SizedBox(height: 30),

            // Hulp
            _buildSettingsButton(
              id: 'hulp',
              title: 'Hulp',
              iconPath: 'assets/images/hulp.png',
              color: themeManager.getOptionYellowSea(),
              themeManager: themeManager,
              onTap: () => _navigateTo(context, const SettingsPageHulp()),
            ),

            const Spacer(),
            // Return button (to SettingsPage - Custom made image)
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationPage(),
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
    );
  }

  /// Navigation helper
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  /// Settings button with dynamic color
  Widget _buildSettingsButton({
    required String id,
    required String title,
    required String iconPath,
    required Color color,
    required ThemeManager themeManager,
    required VoidCallback onTap,
  }) {
    final isPressed = _pressedButton == id;

    // Use ThemeManager's darkenColor when pressed
    final Color displayColor =
        isPressed ? themeManager.darkenColor(color, 0.25) : color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = id),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() => _pressedButton = '');
          onTap();
        });
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: displayColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: isPressed ? 6 : 12,
              offset: Offset(0, isPressed ? 4 : 8),
            ),
          ],
        ),
        child: Row(
          children: [
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
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
