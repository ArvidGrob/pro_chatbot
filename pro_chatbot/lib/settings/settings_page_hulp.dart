import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
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

              // Contact opnemen -> Bright Pink
              _buildButton(
                themeManager,
                buttonId: 'contact',
                label: 'Contact opnemen',
                baseColor: themeManager.getOptionBrightPink(),
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

              // Over section -> Blaze Orange
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeManager.getOptionBlazeOrange(),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
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
                    Container(height: 2.0, color: Colors.white),

                    // Appversie -> Yellow Sea
                    _buildSubButton(
                      themeManager,
                      buttonId: 'appversie',
                      label: 'Appversie',
                      baseColor: themeManager.getOptionYellowSea(),
                      onTap: () {
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
                    ),

                    Container(height: 2.0, color: Colors.white),

                    // Ontwikkelaar -> Light Blue
                    _buildSubButton(
                      themeManager,
                      buttonId: 'ontwikkelaar',
                      label: 'Ontwikkelaar',
                      baseColor: themeManager.getOptionLightBlue(),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      onTap: () {
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
    );
  }

  /// Main buttons
  Widget _buildButton(
    ThemeManager themeManager, {
    required String buttonId,
    required String label,
    required VoidCallback onTap,
    required Color baseColor,
  }) {
    bool isPressed = _pressedButton == buttonId;

    final Color activePressedColor = themeManager.darkenColor(baseColor, 0.15);

    Color buttonColor = isPressed ? activePressedColor : baseColor;

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

  /// Sub-buttons
  Widget _buildSubButton(
    ThemeManager themeManager, {
    required String buttonId,
    required String label,
    required VoidCallback onTap,
    required Color baseColor,
    BorderRadius? borderRadius,
  }) {
    bool isPressed = _pressedButton == buttonId;

    final Color activePressedColor = themeManager.darkenColor(baseColor, 0.25);
    Color buttonColor = isPressed ? activePressedColor : baseColor;

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
          borderRadius: borderRadius,
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
