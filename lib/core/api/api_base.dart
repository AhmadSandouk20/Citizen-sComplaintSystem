import '../config/app_config.dart';

/// Kept as a compatibility alias for the admin data layer.
///
/// The real value lives in [AppConfig.apiBaseUrl], which resolves per platform
/// and honours `--dart-define=API_BASE_URL`. Do not hardcode a host here.
@Deprecated('Use AppConfig.apiBaseUrl; DioClient already sets the base URL.')
String get baseUrl => AppConfig.apiBaseUrl;
