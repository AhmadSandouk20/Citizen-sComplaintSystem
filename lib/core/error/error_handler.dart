import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorHandler {
  static AppException fromDioException(DioException e) {
    String message;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request timed out. Please try again.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Response timed out. Please try again.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Invalid certificate.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final serverMessage = data['message'] ?? 'An error occurred';
          if (data.containsKey('errors')) {
            final errors = data['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            } else {
              message = serverMessage.toString();
            }
          } else {
            message = serverMessage.toString();
          }
        } else {
          message = 'Server error (${statusCode ?? 'unknown'})';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'Network error. Please check your connection.';
        break;
      case DioExceptionType.unknown:
        message = 'Unexpected error. Please try again.';
        break;
      case DioExceptionType.transformTimeout:
        message = 'Request timed out. Please try again.';
        break;
    }

    return AppException(message, statusCode: e.response?.statusCode);
  }
}
