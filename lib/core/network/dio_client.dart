import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/api_base.dart';

import 'package:flutter/foundation.dart';

class DioClient {
  DioClient({
    required String? Function() tokenProvider,
    VoidCallback? onUnauthorized,
  }) : _tokenProvider = tokenProvider,
       _onUnauthorized = onUnauthorized {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final String? Function() _tokenProvider;
  final VoidCallback? _onUnauthorized;
  late final Dio _dio;

  Dio get client => _dio;
}
