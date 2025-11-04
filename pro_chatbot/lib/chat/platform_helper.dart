import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper class to check platform capabilities
class PlatformHelper {
  /// Check if camera is available on current platform
  static bool get isCameraAvailable {
    if (kIsWeb) {
      // Web supports camera through browser API
      return true;
    }
    // Camera available on Android and iOS
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if gallery/photo picker is available
  static bool get isGalleryAvailable {
    // Gallery available on all platforms
    return true;
  }

  /// Check if file picker is available
  static bool get isFilePickerAvailable {
    // File picker available on all platforms
    return true;
  }

  /// Check if speech to text is available
  static bool get isSpeechToTextAvailable {
    if (kIsWeb) {
      // Web has limited speech support
      return true;
    }
    // Available on Android, iOS, macOS, and Windows
    return Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows;
  }

  /// Check if microphone recording is available
  static bool get isRecordingAvailable {
    // Recording available on all platforms
    return true;
  }

  /// Get platform name for display
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if running on desktop platform
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// Check if running on mobile platform
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if running on ChromeOS
  static bool get isChromeOS {
    if (kIsWeb) return false;
    // ChromeOS is detected as Linux in Flutter
    // This is a heuristic check
    return Platform.isLinux &&
        Platform.environment.containsKey('CHROME_DESKTOP');
  }
}
