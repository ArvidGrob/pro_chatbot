import 'package:flutter/material.dart';
import '/theme_manager.dart';
import 'package:provider/provider.dart';
import '/wave_background_layout.dart'; // Import the new layout
import 'settings_page.dart'; // Import the target settings page

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPageThema(),
      ),
    ),
  );
}

// StatefulWidget to manage theme settings
class SettingsPageThema extends StatelessWidget {
  const SettingsPageThema({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Title
          const Text(
            'Thema',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A2AFF),
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle (changes color dynamically)
          Text(
            'Achtergrond kleur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeManager.subtitleTextColor,
            ),
          ),

          const SizedBox(height: 20),

          // Background color options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 'White' color option box
              _colorOption(
                title: 'Wit',
                color: Colors.white,
                selected: themeManager.isWhiteSelected,
                onTap: () => themeManager.switchBackground(true),
                containerColor: themeManager.getOptionSoftBlue(),
              ),
              const SizedBox(width: 20),
              // 'Black' color option box
              _colorOption(
                title: 'Zwart',
                color: Colors.black87,
                selected: !themeManager.isWhiteSelected,
                onTap: () => themeManager.switchBackground(false),
                containerColor: themeManager.getOptionBrightPink(),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Colorblind toggle box inside of row and color IBM Color Scheme
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeManager.getOptionBlazeOrange(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                // Row with Colorblind text and switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kleurenblind IBM Design',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: themeManager.isColorBlindMode,
                      onChanged: (val) =>
                          themeManager.toggleColorBlindMode(val),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // IBM colorblind palette display (progressive)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeManager.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorTile('Soft blue', const Color(0xFF785ef0)),
                      _colorTile('Bright pink', const Color(0xFFdc267f)),
                      _colorTile('Blaze Orange', const Color(0xFFfe6100)),
                      _colorTile('Yellow Sea', const Color(0xFFffb000)),
                      _colorTile('Light blue', const Color(0xFF648fff)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Return button (to SettingsPage - Custom made image)
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
    );
  }

  /// Builds the background color selection box on top (black/white)
  Widget _colorOption({
    required String title,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
    required Color containerColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: selected ? Colors.cyanAccent : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds each colorblind color tile
  Widget _colorTile(String label, Color color) {
    return Flexible(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: RotatedBox(
            quarterTurns: 3, // rotate label vertically
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
