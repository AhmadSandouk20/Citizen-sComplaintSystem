import '../config/app_config.dart';

/// Turns a stored file path from the API into a URL the app can load.
///
/// The backend returns paths like `storage/complaints/12/photo.jpg`, sometimes
/// with a leading slash and sometimes already absolute.
class FileUrlBuilder {
  FileUrlBuilder._();

  static String build(String? path) {
    if (path == null || path.trim().isEmpty) return '';

    final value = path.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final origin = AppConfig.serverOrigin;
    return value.startsWith('/') ? '$origin$value' : '$origin/$value';
  }
}
