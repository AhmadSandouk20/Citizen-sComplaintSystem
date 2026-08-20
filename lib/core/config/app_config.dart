class AppConfig {
  AppConfig._();

  static const String host = '127.0.0.1';
  static const int port = 8000;

  static const String baseUrl = 'http://$host:$port';

  static const String apiBaseUrl = '$baseUrl/api';

  static const int maxAttachmentSizeInBytes = 10 * 1024 * 1024;

  static const int imageQuality = 75;
}