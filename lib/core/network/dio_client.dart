import 'package:dio/dio.dart';
import 'package:final_flutter/core/config/app_config.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient({
    required String? Function() tokenProvider,
    VoidCallback? onUnauthorized,
  }) : _tokenProvider = tokenProvider,
       _onUnauthorized = onUnauthorized {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
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

  static AppException mapError(Object error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final status = error.response?.statusCode;
      final data = error.response?.data;
      String message = error.message ?? 'Request failed';
      if (data is Map && data['message'] is String) {
        message = data['message'] as String;
      }
      switch (status) {
        case 401:
          return const AppException(
            'Session expired. Please log in again.',
            statusCode: 401,
          );
        case 403:
          return const AppException(
            'You do not have permission to do this.',
            statusCode: 403,
          );
        case 422:
          return AppException(message, statusCode: 422);
        case 429:
          return const AppException(
            'Too many requests. Please wait and try again.',
            statusCode: 429,
          );
      }
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const AppException(
            'Cannot reach the server. Make sure Laravel is running.',
          );
        default:
          return AppException(message, statusCode: status);
      }
    }
    return AppException(error.toString());
  }
}
