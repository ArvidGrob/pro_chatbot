import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:provider/provider.dart';
import '/wave_background_layout.dart';
import '/theme_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPageSpraak(),
      ),
    ),
  );
}

class SettingsPageSpraak extends StatefulWidget {
  const SettingsPageSpraak({super.key});

  @override
  State<SettingsPageSpraak> createState() => _SettingsPageSpraakState();
}

class _SettingsPageSpraakState extends State<SettingsPageSpraak> {
  String _selectedVoice = 'vrouwelijk'; // 'vrouwelijk' or 'mannelijk'
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      body: WaveBackgroundLayout(
        backgroundColor: themeManager.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Title with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Spraak',
                      style: TextStyle(
                        color: Color(0xFF6464FF),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/images/spraak_2.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Voice selection button
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _pressedButton = 'voice';
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _pressedButton = '';
                      // Toggle between voices
                      _selectedVoice = _selectedVoice == 'vrouwelijk'
                          ? 'mannelijk'
                          : 'vrouwelijk';
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _pressedButton = '';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: _pressedButton == 'voice'
                          ? const Color(0xFF4545BD)
                          : const Color(0xFF2323AD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vrouwelijke stem row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Vrouwelijke stem',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: _selectedVoice == 'vrouwelijk'
                                  ? Image.asset(
                                      'assets/images/check.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.contain,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Mannelijke stem row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mannelijke stem',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: _selectedVoice == 'mannelijk'
                                  ? Image.asset(
                                      'assets/images/check.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.contain,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

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
      ),
    );
  }
}
