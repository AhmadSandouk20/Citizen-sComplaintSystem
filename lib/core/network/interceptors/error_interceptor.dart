import 'package:dio/dio.dart';
import '../token_storage.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // إذا كان الخطأ 401 (توكن غير صالح أو منتهي)
    if (err.response?.statusCode == 401) {
      // احذف التوكن الفاسد
      TokenStorage.deleteToken();
      // هنا يمكنك إضافة منطق لتوجيه المستخدم لشاشة الدخول
      // (سنفعله لاحقاً عبر الـ GoRouter)
    }

    // إذا كان الخطأ 429 (طلبات كثيرة جداً)
    if (err.response?.statusCode == 429) {
      // يمكنك إضافة رسالة للمستخدم "Too many requests, try again later"
    }

    handler.next(err);
  }
}
