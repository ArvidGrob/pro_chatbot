import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  bool _isColorBlindMode = false;
  bool _isWhiteSelected = true;

  bool get isColorBlindMode => _isColorBlindMode;
  bool get isWhiteSelected => _isWhiteSelected;

  static const Color defaultPrimary = Color(0xFF6464FF);
  static const Color defaultBackgroundLight = Colors.white;
  static const Color defaultBackgroundDark = Colors.black87;

  static const List<Color> ibmColorBlindPalette = [
    Color(0xFF785ef0), // Soft Blue
    Color(0xFFdc267f), // Bright Pink
    Color(0xFFfe6100), // Blaze Orange
    Color(0xFFffb000), // Yellow Sea
    Color(0xFF648fff), // Light Blue
  ];

  Color get backgroundColor =>
      _isWhiteSelected ? defaultBackgroundLight : defaultBackgroundDark;

  Color get primaryColor =>
      _isColorBlindMode ? ibmColorBlindPalette[0] : defaultPrimary;

  Color get subtitleTextColor =>
      _isWhiteSelected ? Color(0xFF252324) : Colors.white;

  Color getOptionSoftBlue() {
    return _isColorBlindMode ? ibmColorBlindPalette[0] : defaultPrimary;
  }

  Color getOptionBrightPink() {
    return _isColorBlindMode ? ibmColorBlindPalette[1] : defaultPrimary;
  }

  Color getOptionBlazeOrange() {
    return _isColorBlindMode ? ibmColorBlindPalette[2] : defaultPrimary;
  }

  Color getOptionYellowSea() {
    return _isColorBlindMode ? ibmColorBlindPalette[3] : defaultPrimary;
  }

  Color getOptionLightBlue() {
    return _isColorBlindMode ? ibmColorBlindPalette[4] : defaultPrimary;
  }

  /// Lighten a color by a given [amount] (0.0 - 1.0)
  Color lightenColor(Color color, [double amount = 0.25]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lighterHsl =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lighterHsl.toColor();
  }

  /// Secondary color is mostly primary but slightly lighter
  Color getSecondaryColor(Color primaryColor, {double lightenAmount = 0.1}) {
    return lightenColor(primaryColor, lightenAmount);
  }

  List<Color> getProgressiveColors(int boxIndex) {
    if (!_isColorBlindMode) {
      return [defaultPrimary];
    }
    int count = boxIndex.clamp(1, ibmColorBlindPalette.length);
    return ibmColorBlindPalette.sublist(0, count);
  }

  /// Darken a color by a given [amount] (0.0 - 1.0)
  Color darkenColor(Color color, [double amount = 0.25]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkerHsl =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkerHsl.toColor();
  }

  void toggleColorBlindMode(bool value) {
    _isColorBlindMode = value;
    notifyListeners();
  }

  void switchBackground(bool isWhite) {
    _isWhiteSelected = isWhite;
    notifyListeners();
  }

  /// Returns the active button color depending on pressed state
  Color getButtonColor(Color baseColor,
      {bool isPressed = false, double darkenAmount = 0.25}) {
    return isPressed ? darkenColor(baseColor, darkenAmount) : baseColor;
  }
}
