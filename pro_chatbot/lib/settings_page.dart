import 'package:flutter/material.dart';

// Temporary main function for debugging/preview
void main() {
  runApp(const SettingsApp());
}

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Preview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SettingsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables for different settings
  int _selectedSettingIndex = -1; // Track which setting is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9C7BE8), // Light purple
              Color(0xFF6B5CE7), // Darker purple
              Color(0xFF4F46E5), // Blue purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section
              _buildHeader(),

              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Settings title
                      const Text(
                        'Instellingen',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46E5),
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Settings options list
                      Expanded(
                        child: _buildSettingsList(),
                      ),

                      // Bottom navigation/back button
                      _buildBottomNavigation(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build header section (empty for now, consistent with designs)
  Widget _buildHeader() {
    return const SizedBox(height: 20);
  }

  // Build main settings list
  Widget _buildSettingsList() {
    return Column(
      children: [
        // Account setting
        _buildSettingItem(
          index: 0,
          title: 'Account',
          icon: Icons.person,
          onTap: () => _handleSettingTap(0),
        ),

        const SizedBox(height: 16),

        // Speech setting
        _buildSettingItem(
          index: 1,
          title: 'Spraak',
          icon: Icons.volume_up,
          onTap: () => _handleSettingTap(1),
        ),

        const SizedBox(height: 16),

        // Language level setting
        _buildSettingItem(
          index: 2,
          title: 'Taal level',
          icon: Icons.school,
          onTap: () => _handleSettingTap(2),
        ),

        const SizedBox(height: 16),

        // Theme setting
        _buildSettingItem(
          index: 3,
          title: 'Thema',
          icon: Icons.palette,
          onTap: () => _handleSettingTap(3),
        ),

        const SizedBox(height: 16),

        // Help setting
        _buildSettingItem(
          index: 4,
          title: 'Hulp',
          icon: Icons.help,
          onTap: () => _handleSettingTap(4),
        ),

        const Spacer(),
      ],
    );
  }

  // Build individual setting item with different styles based on state
  Widget _buildSettingItem({
    required int index,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    // Determine styling based on selection state and design variations
    Color backgroundColor = _getSettingBackgroundColor(index);
    Color textColor = _getSettingTextColor(index);
    Color iconColor = _getSettingIconColor(index);
    bool showArrow = _shouldShowArrow(index);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Setting icon
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),

            const SizedBox(width: 16),

            // Setting title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),

            // Arrow indicator (for navigation)
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  // Build bottom navigation with back button
  Widget _buildBottomNavigation() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // Get background color for setting item based on design state
  Color _getSettingBackgroundColor(int index) {
    // Different designs show different color schemes
    switch (index) {
      case 0: // Account
        return _selectedSettingIndex == 0
            ? const Color(0xFF4F46E5)
            : Colors.white.withOpacity(0.9);
      case 1: // Speech
        return _selectedSettingIndex == 1
            ? const Color(0xFF4F46E5)
            : Colors.white.withOpacity(0.9);
      case 2: // Language level
        return _selectedSettingIndex == 2
            ? const Color(0xFF4F46E5)
            : Colors.white.withOpacity(0.9);
      case 3: // Theme
        return _selectedSettingIndex == 3
            ? const Color(0xFF4F46E5)
            : Colors.white.withOpacity(0.9);
      case 4: // Help
        return _selectedSettingIndex == 4
            ? const Color(0xFF4F46E5)
            : Colors.white.withOpacity(0.9);
      default:
        return Colors.white.withOpacity(0.9);
    }
  }

  // Get text color for setting item
  Color _getSettingTextColor(int index) {
    return _selectedSettingIndex == index
        ? Colors.white
        : const Color(0xFF4F46E5);
  }

  // Get icon color for setting item
  Color _getSettingIconColor(int index) {
    return _selectedSettingIndex == index
        ? Colors.white
        : const Color(0xFF4F46E5);
  }

  // Determine if arrow should be shown
  bool _shouldShowArrow(int index) {
    // All items now show arrows
    return true;
  }

  // Handle setting item tap
  void _handleSettingTap(int index) {
    setState(() {
      _selectedSettingIndex = _selectedSettingIndex == index ? -1 : index;
    });

    // Show placeholder dialog for demonstration
    _showSettingDialog(index);
  }

  // Show setting dialog (placeholder functionality)
  void _showSettingDialog(int index) {
    String title = '';
    String content = '';

    switch (index) {
      case 0:
        title = 'Account';
        content = 'Account instellingen worden hier weergegeven.';
        break;
      case 1:
        title = 'Spraak';
        content = 'Spraak instellingen worden hier weergegeven.';
        break;
      case 2:
        title = 'Taal level';
        content = 'Taalniveau instellingen worden hier weergegeven.';
        break;
      case 3:
        title = 'Thema';
        content = 'Thema instellingen worden hier weergegeven.';
        break;
      case 4:
        title = 'Hulp';
        content = 'Hulp informatie wordt hier weergegeven.';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                _getIconForIndex(index),
                color: const Color(0xFF4F46E5),
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Get appropriate icon for each setting
  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.volume_up;
      case 2:
        return Icons.school;
      case 3:
        return Icons.palette;
      case 4:
        return Icons.help;
      default:
        return Icons.settings;
    }
  }
}
