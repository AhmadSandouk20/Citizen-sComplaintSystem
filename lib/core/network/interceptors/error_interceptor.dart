import 'package:dio/dio.dart';

/// Reacts to a 401 by tearing down the session exactly once.
///
/// Message mapping lives in `DioClient.mapError` — this interceptor only owns
/// the side effect that cannot be expressed as a return value.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._onUnauthorized);

  final void Function() _onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _onUnauthorized();
    }
    handler.next(err);
  }
}
