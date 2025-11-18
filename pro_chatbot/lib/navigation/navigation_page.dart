import 'package:flutter/material.dart';
import 'package:pro_chatbot/chat/chat_page.dart';
import '../settings/settings_page.dart';
import '../admindashboard/admin_dashboard.dart';
import '../training/training_page.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '/api/user_provider.dart';
import '/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NavigationPage(),
      ),
    ),
  );
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
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              _buildNavigationButton(
                id: 'chat',
                title: 'Chat',
                iconPath: 'assets/images/chat.png',
                primaryColor: themeManager.getOptionSoftBlue(),
                secondaryColor: themeManager
                    .getSecondaryColor(themeManager.getOptionSoftBlue()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildNavigationButton(
                id: 'training',
                title: 'Training',
                iconPath: 'assets/images/training.png',
                primaryColor: themeManager.getOptionBrightPink(),
                secondaryColor: themeManager
                    .getSecondaryColor(themeManager.getOptionBrightPink()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrainingPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildNavigationButton(
                      id: 'instellingen',
                      title: 'Instellingen',
                      iconPath: 'assets/images/settings.png',
                      primaryColor: themeManager.getOptionBlazeOrange(),
                      secondaryColor: themeManager.getSecondaryColor(
                          themeManager.getOptionBlazeOrange()),
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
                  const SizedBox(width: 30),
                  Expanded(
                    child: _buildNavigationButton(
                      id: 'admin',
                      title: 'Admin',
                      iconPath: 'assets/images/admin.png',
                      primaryColor: themeManager.getOptionYellowSea(),
                      secondaryColor: themeManager
                          .getSecondaryColor(themeManager.getOptionYellowSea()),
                      onTap: () {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        if (userProvider.hasRole(Role.admin) ||
                            userProvider.hasRole(Role.teacher)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDashboard(),
                            ),
                          );
                        } else {
                          // Create a list of allowed roles
                          final allowedRoles = [Role.admin, Role.teacher];
                          final roleNames = allowedRoles
                              .map((role) => role.toString().split('.').last)
                              .join(' of ');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                          "Toegang geweigerd. Deze pagina vereist de rol ",
                                    ),
                                    TextSpan(
                                      text: roleNames,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
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
    );
  }

  Widget _buildNavigationButton({
    required String id,
    required String title,
    required String iconPath,
    required Color primaryColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final isPressed = _pressedButton == id;

    // Darken both primary and secondary when pressed
    final Color displayPrimary =
        isPressed ? themeManager.darkenColor(primaryColor, 0.25) : primaryColor;

    final Color displaySecondary = isPressed
        ? themeManager.darkenColor(secondaryColor, 0.25)
        : secondaryColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = id),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() => _pressedButton = '');
          onTap();
        });
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
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
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
}
