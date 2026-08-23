/// A user-presentable failure.
///
/// Everything that leaves the data layer is either a value or an
/// [AppException]; no `DioException` ever reaches a Cubit or a Widget.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  /// Field-level errors returned by Laravel on a 422 response,
  /// shaped as `{ "email": ["The email is invalid."] }`.
  final Map<String, List<String>>? fieldErrors;

  const AppException(this.message, {this.statusCode, this.fieldErrors});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isValidation => statusCode == 422;
  bool get isRateLimited => statusCode == 429;

  /// First error message for [field], if the server reported one.
  String? errorFor(String field) => fieldErrors?[field]?.firstOrNull;

  @override
  String toString() => message;
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
