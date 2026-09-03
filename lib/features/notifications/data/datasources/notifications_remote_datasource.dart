import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/core/shared/paginated_result.dart';
import 'package:final_flutter/features/notifications/data/models/notification_model.dart';

class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<PaginatedResult<NotificationModel>> fetchNotifications({
    int page = 1,
    int perPage = 15,
    bool? isRead,
  }) async {
    try {
      final response = await _dioClient.client.get(
        '/notifications',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'is_read': ?isRead,
        },
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AppException('Unexpected notifications response.');
      }
      return PaginatedResult.fromJson(data, NotificationModel.fromJson);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  /// Marks one notification as read.
  ///
  /// Returns nothing on purpose: the response body only confirms the flag, and
  /// the previous version fabricated a `NotificationModel` with an empty title
  /// and `DateTime.now()` to fill the return type. The Cubit patches its own
  /// item locally, which is both accurate and cheaper.
  Future<void> markAsRead(int id) async {
    try {
      await _dioClient.client.patch('/notifications/$id/read');
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<void> saveFcmToken({
    required String token,
    String deviceType = 'android',
    String? deviceId,
  }) async {
    try {
      await _dioClient.client.post(
        '/notifications/fcm-token',
        data: {
          'fcm_token': token,
          'device_type': deviceType,
          'device_id': ?deviceId,
        },
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<void> deleteFcmToken(String token) async {
    try {
      await _dioClient.client.delete(
        '/notifications/fcm-token',
        data: {'fcm_token': token},
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }
}
