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
    Color(0xFF785ef0), // 'Soft blue'
    Color(0xFFdc267f), // 'Bright pink'
    Color(0xFFfe6100), // 'Blaze Orange'
    Color(0xFFffb000), // 'Yellow Sea'
  ];

  Color get backgroundColor =>
      _isWhiteSelected ? defaultBackgroundLight : defaultBackgroundDark;

  Color get primaryColor =>
      _isColorBlindMode ? ibmColorBlindPalette[0] : defaultPrimary;

  /// 🔹 New getter for dynamic subtitle text color
  Color get subtitleTextColor =>
      _isWhiteSelected ? Colors.black87 : Colors.white;

  // 🔹 NEW: Get different container colors for white and black options
  Color getOptionSoftblue() {
    return _isColorBlindMode ? ibmColorBlindPalette[0] : defaultPrimary;
  }

  Color getOptionBrightpink() {
    return _isColorBlindMode ? ibmColorBlindPalette[1] : defaultPrimary;
  }

  Color getOptionBlazeOrange() {
    return _isColorBlindMode ? ibmColorBlindPalette[2] : defaultPrimary;
  }

  Color getOptionYellowSea() {
    return _isColorBlindMode ? ibmColorBlindPalette[3] : defaultPrimary;
  }

  List<Color> getProgressiveColors(int boxIndex) {
    if (!_isColorBlindMode) {
      return [defaultPrimary];
    }
    int count = boxIndex.clamp(1, ibmColorBlindPalette.length);
    return ibmColorBlindPalette.sublist(0, count);
  }

  void toggleColorBlindMode(bool value) {
    _isColorBlindMode = value;
    notifyListeners();
  }

  void switchBackground(bool isWhite) {
    _isWhiteSelected = isWhite;
    notifyListeners();
  }
}
