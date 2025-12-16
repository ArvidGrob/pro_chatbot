import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:provider/provider.dart';
import '/wave_background_layout.dart';
import '/theme_manager.dart';
import '../tts_setting.dart';

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
                      color: themeManager.getOptionSoftBlue(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Female voice
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
                            if (_selectedVoice ==
                                'vrouwelijk') // Function still to be implemented
                              Image.asset(
                                'assets/images/check.png',
                                width: 30,
                                height: 30,
                              ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Male voice
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
                            if (_selectedVoice ==
                                'mannelijk') // Function still to be implemented
                              Image.asset(
                                'assets/images/check.png',
                                width: 30,
                                height: 30,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Speech rate slider
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
                        'Spreeksnelheid',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.2),
                          valueIndicatorColor: Colors.white,
                          valueIndicatorTextStyle: const TextStyle(
                            color:
                                Color(0xFF2A2AFF), // matches theme title color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: TtsSettings.speechRate,
                          min: 0.0,
                          max: 2.0,
                          divisions: 20,
                          label: TtsSettings.speechRate.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              TtsSettings.speechRate = value;
                            });
                          },
                        ),
                      ),
                    ],
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
