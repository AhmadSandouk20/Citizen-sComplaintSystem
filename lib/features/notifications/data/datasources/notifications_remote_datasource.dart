import 'package:dio/dio.dart';
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
          if (isRead != null) 'is_read': isRead,
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

  Future<NotificationModel> markAsRead(int id) async {
    try {
      final response = await _dioClient.client.patch('/notifications/$id/read');
      final data = response.data;
      if (data is Map<String, dynamic> && data['notification'] is Map) {
        final nested = Map<String, dynamic>.from(data['notification'] as Map);
        return NotificationModel(
          id: nested['id'] as int? ?? id,
          title: '',
          body: '',
          type: '',
          isRead: nested['is_read'] == true || nested['is_read'] == 1,
          createdAt: DateTime.now(),
          readAt: DateTime.tryParse(nested['read_at']?.toString() ?? ''),
        );
      }
      return NotificationModel(
        id: id,
        title: '',
        body: '',
        type: '',
        isRead: true,
        createdAt: DateTime.now(),
        readAt: DateTime.now(),
      );
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
          if (deviceId != null) 'device_id': deviceId,
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
    } on DioException catch (error) {
      throw DioClient.mapError(error);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }
}
