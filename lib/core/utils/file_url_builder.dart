import '../config/app_config.dart';

class FileUrlBuilder {
  FileUrlBuilder._();

  static String build(String? path) {
    if (path == null || path.trim().isEmpty) {
      return '';
    }

    final value = path.trim();

    if (value.startsWith('http://127.0.0.1:8000')) {
      return value.replaceFirst(
        'http://127.0.0.1:8000',
        AppConfig.baseUrl,
      );
    }

    if (value.startsWith('http://localhost:8000')) {
      return value.replaceFirst(
        'http://localhost:8000',
        AppConfig.baseUrl,
      );
    }

    if (value.startsWith('http://') ||
        value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('/')) {
      return '${AppConfig.baseUrl}$value';
    }

    return '${AppConfig.baseUrl}/$value';
  }
}