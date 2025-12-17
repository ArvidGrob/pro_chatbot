import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  bool _isColorBlindMode = false;
  bool _isWhiteSelected = true;

  bool get isColorBlindMode => _isColorBlindMode;
  bool get isWhiteSelected => _isWhiteSelected;

  /// Default (non–colorblind) theme colors
  static const Color defaultPrimary = Color(0xFF6464FF);
  static const Color defaultBackgroundLight = Colors.white;
  static const Color defaultBackgroundDark = Colors.black87;

  /// IBM Color Blind Safe Palette
  static const List<Color> ibmColorBlindPalette = [
    Color(0xFF785EF0), // Soft Blue
    Color(0xFFDC267F), // Bright Pink
    Color(0xFFFE6100), // Blaze Orange
    Color(0xFFFFB000), // Yellow Sea
    Color(0xFF648FFF), // Light Blue
  ];

  /// Base colors

  Color get backgroundColor =>
      _isWhiteSelected ? defaultBackgroundLight : defaultBackgroundDark;

  Color get subtitleTextColor =>
      _isWhiteSelected ? const Color(0xFF252324) : Colors.white;

  /// Primary brand color
  Color get primaryColor =>
      _isColorBlindMode ? ibmColorBlindPalette.first : defaultPrimary;

  /// Container / UI colors

  /// Returns a stable container color based on index
  /// index: 0 → first container, 1 → second, etc.
  Color getContainerColor(int index) {
    if (!_isColorBlindMode) {
      return defaultPrimary;
    }

    return ibmColorBlindPalette[index % ibmColorBlindPalette.length];
  }

  /// Returns a lighter secondary version of a container color
  Color getSecondaryContainerColor(
    int index, {
    double lightenAmount = 0.15,
  }) {
    return lightenColor(getContainerColor(index), lightenAmount);
  }

  /// Color utilities

  /// Lighten a color by a given [amount] (0.0 - 1.0)
  Color lightenColor(Color color, [double amount = 0.25]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken a color by a given [amount] (0.0 - 1.0)
  Color darkenColor(Color color, [double amount = 0.25]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Button press feedback
  Color getButtonColor(
    Color baseColor, {
    bool isPressed = false,
    double darkenAmount = 0.25,
  }) {
    return isPressed ? darkenColor(baseColor, darkenAmount) : baseColor;
  }

  /// ===============================
  /// State toggles
  /// ===============================

  void toggleColorBlindMode(bool value) {
    _isColorBlindMode = value;
    notifyListeners();
  }

  void switchBackground(bool isWhite) {
    _isWhiteSelected = isWhite;
    notifyListeners();
  }
}
