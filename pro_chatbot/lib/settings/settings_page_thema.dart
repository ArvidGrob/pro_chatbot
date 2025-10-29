import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SettingsPageThema(),
  ));
}

class SettingsPageThema extends StatefulWidget {
  const SettingsPageThema({super.key});

  @override
  State<SettingsPageThema> createState() => _SettingsPageThemaState();
}

class _SettingsPageThemaState extends State<SettingsPageThema> {
  bool isColorBlindMode = false;
  bool isWhiteSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Thema',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A2AFF),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Achtergrond kleur',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Background color selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _colorOption(
                    title: 'Wit',
                    color: Colors.white,
                    selected: isWhiteSelected,
                    onTap: () {
                      setState(() {
                        isWhiteSelected = true;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _colorOption(
                    title: 'Zwart',
                    color: Colors.black,
                    selected: !isWhiteSelected,
                    onTap: () {
                      setState(() {
                        isWhiteSelected = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Colorblind toggle section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kleurenblind',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Switch(
                          value: isColorBlindMode,
                          onChanged: (val) {
                            setState(() {
                              isColorBlindMode = val;
                            });
                          },
                          activeColor: Colors.blueAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _colorTile('Vivid blue', Colors.blue),
                        _colorTile('Pink-red', Colors.pink),
                        _colorTile('Orange', Colors.orange),
                        _colorTile('Green-cyan', Colors.cyan),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Return button (custom)
              Center(
                child: _buildReturnButton(
                  iconPath: 'assets/images/return.png',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the background color selection box
  Widget _colorOption({
    required String title,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: selected ? Colors.blue : Colors.transparent,
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
              color: Color(0xFF2A2AFF),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds each colorblind color tile
  Widget _colorTile(String label, Color color) {
    return Container(
      width: 60,
      height: 100,
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
          quarterTurns: 3,
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
    );
  }

  /// Custom return button builder
  Widget _buildReturnButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Image.asset(
          iconPath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
