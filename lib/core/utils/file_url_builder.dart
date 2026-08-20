import '../config/app_config.dart';

class FileUrlBuilder {
  FileUrlBuilder._();

  static String build(String? path) {
    if (path == null || path.trim().isEmpty) {
      return '';
    }

    final value = path.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('/')) {
      return '${AppConfig.baseUrl}$value';
    }

    return '${AppConfig.baseUrl}/$value';
  }
}