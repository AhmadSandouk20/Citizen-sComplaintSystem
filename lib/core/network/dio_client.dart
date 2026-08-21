import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioClient {
  static final Dio _instance =
      Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:8000/api',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          AuthInterceptor(),
          ErrorInterceptor(),
          PrettyDioLogger(requestBody: true, responseBody: true),
        ]);

  static Dio get instance => _instance;
}
