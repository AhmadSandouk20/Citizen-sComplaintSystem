import 'package:dio/dio.dart';

/// Attaches the bearer token to every outgoing request.
///
/// The token is pulled through a callback instead of being read from storage
/// here, so the source of truth stays [AuthCubit] and the interceptor has no
/// dependency on the auth feature.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final String? Function() _tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
