import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// The single Dio instance for the whole app.
///
/// Registered once in the injector; every data source takes it as a
/// dependency. Nobody constructs a bare `Dio()` anywhere else.
class DioClient {
  DioClient({
    required String? Function() tokenProvider,
    required void Function() onUnauthorized,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(tokenProvider),
      ErrorInterceptor(onUnauthorized),
    ]);

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true),
      );
    }
  }

  late final Dio _dio;

  Dio get client => _dio;

  /// Turns anything thrown by Dio into an [AppException] carrying a message
  /// the UI can show as-is. Covers the four status codes the review checklist
  /// requires: 401, 403, 422, 429.
  static AppException mapError(Object error) {
    if (error is AppException) return error;

    if (error is! DioException) {
      return AppException(error.toString());
    }

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
      case 404:
        return AppException(message, statusCode: 404);
      case 422:
        return AppException(
          message,
          statusCode: 422,
          fieldErrors: _parseFieldErrors(data),
        );
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
          'Cannot reach the server. Make sure the API is running.',
        );
      default:
        return AppException(message, statusCode: status);
    }
  }

  static Map<String, List<String>>? _parseFieldErrors(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is! Map) return null;

    final parsed = <String, List<String>>{};
    errors.forEach((key, value) {
      if (value is List) {
        parsed['$key'] = value.map((e) => '$e').toList();
      } else if (value != null) {
        parsed['$key'] = ['$value'];
      }
    });
    return parsed.isEmpty ? null : parsed;
  }
}
