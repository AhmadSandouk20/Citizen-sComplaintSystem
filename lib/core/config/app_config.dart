import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  /// Web Push public key from Firebase > Project settings > Cloud Messaging.
  static const vapidKey =
      'BK7vVN9W4N62Z0mlDnk9ja_x0PZpCorWlcz0Q6UdrX84nvV3S7De0vUGBSW-8tUWVAPSYePBdNIed7sQ8wDwjPA';

  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api';
      default:
        return 'http://127.0.0.1:8000/api';
    }
  }
}
