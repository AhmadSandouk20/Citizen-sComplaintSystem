import 'package:dio/dio.dart';
import '../token_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // جلب التوكن من التخزين
    final token = await TokenStorage.getToken();

    // إذا كان التوكن موجوداً، أضفه إلى الـ Header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
