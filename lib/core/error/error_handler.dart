import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import 'app_exception.dart';

/// Compatibility wrapper over [DioClient.mapError].
///
/// The admin repositories were written against this class; keeping it as a
/// delegate means there is still only one place that decides what an HTTP
/// failure says to the user.
class ErrorHandler {
  ErrorHandler._();

  static AppException fromDioException(DioException e) =>
      DioClient.mapError(e);

  /// Accepts anything thrown, not just a [DioException].
  static AppException from(Object error) => DioClient.mapError(error);
}
