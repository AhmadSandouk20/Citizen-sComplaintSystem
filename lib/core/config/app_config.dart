import 'package:flutter/foundation.dart';

/// Single source of truth for environment values.
///
/// Nothing in the app may hardcode a host, a port or a limit — everything
/// comes from here, and everything here can be overridden at build time:
///
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.105:8000/api
class AppConfig {
  AppConfig._();

  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Web Push public key (Firebase > Project settings > Cloud Messaging).
  /// This is a public client identifier, not a secret.
  static const String vapidKey =
      'BK7vVN9W4N62Z0mlDnk9ja_x0PZpCorWlcz0Q6UdrX84nvV3S7De0vUGBSW-8tUWVAPSYePBdNIed7sQ8wDwjPA';

  /// Origin of the Laravel server, without the `/api` suffix.
  /// Used to build absolute URLs for stored files (attachments, images).
  static String get serverOrigin {
    final api = apiBaseUrl;
    return api.endsWith('/api') ? api.substring(0, api.length - 4) : api;
  }

  /// Base URL of the API, resolved per platform.
  ///
  /// The Android emulator cannot reach the host machine on `127.0.0.1`;
  /// it must use `10.0.2.2`. A physical device needs the LAN address,
  /// which is what the `--dart-define` override is for.
  static String get apiBaseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;

    if (kIsWeb) return 'http://127.0.0.1:8000/api';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api';
      default:
        return 'http://127.0.0.1:8000/api';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Backend rejects any attachment above 10240 KB.
  static const int maxAttachmentSizeInBytes = 10 * 1024 * 1024;

  /// Quality used when compressing a picked image before upload.
  static const int imageQuality = 75;

  /// Default page size used by the API (`per_page`).
  static const int defaultPageSize = 15;
}
