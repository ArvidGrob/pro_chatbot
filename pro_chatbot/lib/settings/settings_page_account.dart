import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'settings_page.dart';
import 'settings_page_account_2_1.dart';
import 'settings_page_account_2_2.dart';

void main() {
  runApp(const TestSettingsAccountApp());
}

class TestSettingsAccountApp extends StatelessWidget {
  const TestSettingsAccountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: MaterialApp(
        title: 'Test Settings Account',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SettingsPageAccount(),
      ),
    );
  }
}

class SettingsPageAccount extends StatefulWidget {
  const SettingsPageAccount({super.key});

  @override
  State<SettingsPageAccount> createState() => _SettingsPageAccountState();
}

class _SettingsPageAccountState extends State<SettingsPageAccount> {
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Color(0xFF2A2AFF),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/account_2.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Informative grey bubble
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF9E9E9E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informatie',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Rol:\nKlas:\nSchool:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Persoonlijke gegevens card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: themeManager.getOptionSoftBlue(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Persoonlijke gegevens',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Voornaam:\nAchternaam:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsPageAccount21(),
                            ),
                          );
                        },
                        child: const Text(
                          'Wijzigen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Wachtwoord wijzigen button -> Blaze Orange
              _buildButton(
                themeManager: themeManager,
                buttonId: 'wachtwoord',
                label: 'Wachtwoord wijzigen',
                baseColor: themeManager.getOptionBlazeOrange(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPageAccount22(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // Uitloggen button -> Red
              _buildButton(
                themeManager: themeManager,
                buttonId: 'uitloggen',
                label: 'Uitloggen',
                baseColor: const Color(0xFFFE445A),
                onTap: () {
                  print('Uitloggen tapped');
                },
                isLogout: true,
              ),

              const SizedBox(height: 40),
              // Return button (to SettingsPage)
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

  /// Generic button with pressed effect
  Widget _buildButton({
    required ThemeManager themeManager,
    required String buttonId,
    required String label,
    required Color baseColor,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor =
        isPressed ? themeManager.darkenColor(baseColor, 0.25) : baseColor;

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
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isLogout)
              Image.asset(
                'assets/images/exit.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }
}
